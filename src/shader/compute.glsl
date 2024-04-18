/* This file is part of Zutty.
 * Copyright (C) 2020 Tom Szilagyi
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * See the file LICENSE for the full license.
 */

#version 310 es

layout (local_size_x = 1, local_size_y = 1) in;
layout (rgba8, binding = 0) writeonly lowp uniform image2D imgOut;
layout (binding = 1) uniform lowp sampler2DArray atlas;
layout (binding = 2) uniform lowp sampler2D atlasMap;
layout (binding = 3) uniform lowp sampler2DArray atlas_dw;
layout (binding = 4) uniform lowp sampler2D atlasMap_dw;
uniform lowp ivec2 glyphPixels;
uniform lowp ivec2 sizeChars;
uniform lowp ivec3 cursorColor;
uniform lowp ivec4 cursorPos; // .xy: current; .zw: previous
uniform lowp int cursorStyle;
uniform lowp ivec4 selectRect;
uniform lowp int selectRectMode;
uniform highp ivec2 selectDamage;
uniform lowp int deltaFrame;
uniform lowp int showWraps;
uniform lowp int hasDoubleWidth;

struct Cell
{
   highp uint charData;
   highp uint fg;
   highp uint bg;
};

layout (std430, binding = 0) buffer CharVideoMem
{
   Cell cells[];
} vmem;

void main ()
{
   ivec2 charPos = ivec2 (gl_GlobalInvocationID.xy);
   int idx = sizeChars.x * charPos.y + charPos.x;
   Cell cell = vmem.cells[idx];

   if (deltaFrame == 1)
   {
      uint dirty = bitfieldExtract (cell.charData, 23, 1);
      if (dirty == 0u &&
          charPos != cursorPos.xy && charPos != cursorPos.zw &&
          (idx < selectDamage.x || idx >= selectDamage.y))
         return;
   }
   vmem.cells[idx].charData = bitfieldInsert (cell.charData, 0u, 23, 1);

   ivec2 charCode =
      ivec2 (bitfieldExtract (cell.charData, 0, 8),  // Lowest byte
             bitfieldExtract (cell.charData, 8, 8)); // Next-lowest byte

   uint dwidth = bitfieldExtract (cell.charData, 16, 1);
   uint dwidth_cont = bitfieldExtract (cell.charData, 17, 1);
   if (dwidth_cont == 1u) // double-width cell continuation - drawn by left half
      return;

   if (dwidth == 1u && charPos.x < sizeChars.x - 1)
   {
      // check validity (dwidth_cont marker in the cell to the right)
      if (bitfieldExtract (vmem.cells[idx + 1].charData, 17, 1) != 1u)
         dwidth = 0u;
   }

   uint fontIdx = 0u; // 0 -> Normal; 1 -> Bold; 2 -> Italic; 3 -> BoldItalic
   if (dwidth == 0u)
      fontIdx = bitfieldExtract (cell.charData, 18, 2);
   uint underline = bitfieldExtract (cell.charData, 20, 1);
   uint inverse = bitfieldExtract (cell.charData, 21, 1);
   uint wrap = bitfieldExtract (cell.charData, 22, 1);

   ivec2 atlasPos;
   if (dwidth == 0u)
      atlasPos = ivec2 (vec2 (256) * texelFetch (atlasMap, charCode, 0).zw);
   else
      atlasPos = ivec2 (vec2 (256) * texelFetch (atlasMap_dw, charCode, 0).zw);

   vec3 fgColor = vec3 (float (bitfieldExtract (cell.fg, 0, 8)),
                        float (bitfieldExtract (cell.fg, 8, 8)),
                        float (bitfieldExtract (cell.fg, 16, 8))) / 255.0;

   vec3 bgColor = vec3 (float (bitfieldExtract (cell.bg, 0, 8)),
                        float (bitfieldExtract (cell.bg, 8, 8)),
                        float (bitfieldExtract (cell.bg, 16, 8))) / 255.0;

   vec3 crColor = vec3 (cursorColor) / 255.0;

   if (selectRectMode == 1)
   {
      if (charPos.y >= selectRect.y && charPos.y <= selectRect.w &&
          charPos.x >= selectRect.x && charPos.x < selectRect.z)
         inverse ^= 1u;
   }
   else if ((charPos.y > selectRect.y && charPos.y < selectRect.w) ||
       (charPos.y == selectRect.y && charPos.x >= selectRect.x &&
        (charPos.y < selectRect.w || charPos.x < selectRect.z)) ||
       (charPos.y == selectRect.w && charPos.x < selectRect.z &&
        (charPos.y > selectRect.y || charPos.x > selectRect.x)))
      inverse ^= 1u;

   if (inverse == 1u)
   {
      vec3 tmp = fgColor;
      fgColor = bgColor;
      bgColor = tmp;
   }
   if (crColor == bgColor)
   {
      crColor = vec3 (1.0) - crColor;
   }
   if (charPos == cursorPos.xy && cursorStyle == 1)
   {
      fgColor = bgColor;
      bgColor = crColor;
   }

   ivec2 srcGlyphPixels = glyphPixels;
   if (dwidth == 1u)
      srcGlyphPixels = ivec2 (2, 1) * glyphPixels;

   if (dwidth == 0u)
   {  // render regular cell
      for (int j = 0; j < glyphPixels.x; j++)
      {
         for (int k = 0; k < glyphPixels.y; k++)
         {
            ivec2 txCoords = atlasPos * srcGlyphPixels + ivec2 (j, k);
            ivec3 txc = ivec3 (txCoords, fontIdx);
            float lumi = texelFetch (atlas, txc, 0).r;
            vec4 pixel = vec4 (fgColor * lumi + bgColor * (1.0 - lumi), 1.0);
            ivec2 pxCoords = charPos * glyphPixels + ivec2 (j, k);
            imageStore (imgOut, pxCoords, pixel);
         }
      }
   }
   else if (hasDoubleWidth == 1)
   {  // render double-width cell
      for (int j = 0; j < srcGlyphPixels.x; j++)
      {
         for (int k = 0; k < srcGlyphPixels.y; k++)
         {
            ivec2 txCoords = atlasPos * srcGlyphPixels + ivec2 (j, k);
            ivec3 txc = ivec3 (txCoords, fontIdx);
            float lumi = texelFetch (atlas_dw, txc, 0).r;
            vec4 pixel = vec4 (fgColor * lumi + bgColor * (1.0 - lumi), 1.0);
            ivec2 pxCoords = charPos * glyphPixels + ivec2 (j, k);
            imageStore (imgOut, pxCoords, pixel);
         }
      }
   }
   else
   {  // no double-width font -- draw an empty box
      for (int j = 0; j < srcGlyphPixels.x; j++)
      {
         for (int k = 0; k < srcGlyphPixels.y; k++)
         {
            float lumi = 0.0;
            if ((0 < j && j < srcGlyphPixels.x - 1) &&
                (0 < k && k < srcGlyphPixels.y - 1) &&
                (j == 1 || j == srcGlyphPixels.x - 2 ||
                 k == 1 || k == srcGlyphPixels.y - 2))
               lumi = 0.7;
            vec4 pixel = vec4 (fgColor * lumi + bgColor * (1.0 - lumi), 1.0);
            ivec2 pxCoords = charPos * glyphPixels + ivec2 (j, k);
            imageStore (imgOut, pxCoords, pixel);
         }
      }
   }

   if (underline == 1u)
   {
      for (int j = 0; j < srcGlyphPixels.x; j++)
      {
         vec4 pixel = vec4 (fgColor, 1.0);
         ivec2 pxCoords = charPos * glyphPixels +
                          ivec2 (j, srcGlyphPixels.y - 1);
         imageStore (imgOut, pxCoords, pixel);
      }
   }

   if (showWraps == 1 && wrap == 1u)
   {
      vec4 pixel = vec4 (fgColor, 1.0);
      for (int k = 0; k < srcGlyphPixels.y; k += 2)
      {
         ivec2 pxCoords = charPos * glyphPixels +
                          ivec2 (srcGlyphPixels.x - 1, k);
         imageStore (imgOut, pxCoords, pixel);
      }
   }

   if (charPos == cursorPos.xy)
   {
      vec4 pixel = vec4 (crColor, 1.0);
      if (cursorStyle == 2)
      {
         for (int j = 0; j < srcGlyphPixels.x; j++)
         {
            ivec2 pxCoords = charPos * glyphPixels + ivec2 (j, 0);
            imageStore (imgOut, pxCoords, pixel);
            pxCoords += ivec2 (0, srcGlyphPixels.y - 1);
            imageStore (imgOut, pxCoords, pixel);
         }
         for (int k = 1; k < srcGlyphPixels.y - 1; k++)
         {
            ivec2 pxCoords = charPos * glyphPixels + ivec2 (0, k);
            imageStore (imgOut, pxCoords, pixel);
            pxCoords += ivec2 (srcGlyphPixels.x - 1, 0);
            imageStore (imgOut, pxCoords, pixel);
         }
      }
      else if (cursorStyle == 3)
      {
         int hoffset = srcGlyphPixels.y - 2;
         for (int j = 0; j < srcGlyphPixels.x; j++)
         {
            ivec2 pxCoords = charPos * glyphPixels + ivec2 (j, hoffset);
            imageStore (imgOut, pxCoords, pixel);
            pxCoords += ivec2 (0, 1);
            imageStore (imgOut, pxCoords, pixel);
         }
      }
      else if (cursorStyle == 4)
      {
         for (int k = 0; k < srcGlyphPixels.y; k++)
         {
            ivec2 pxCoords = charPos * glyphPixels + ivec2 (0, k);
            imageStore (imgOut, pxCoords, pixel);
            pxCoords += ivec2 (1, 0);
            imageStore (imgOut, pxCoords, pixel);
         }
      }
   }
}
