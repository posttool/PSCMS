package com.pagesociety.cms
{
    import flash.display.GradientType;
    import flash.display.Graphics;
    import flash.display.SpreadMethod;
    import flash.geom.Matrix;

    public class Constants
    {
        public static const COLOR_1:uint = 0x0099ff;
        public static const COLOR_BLACK:uint = 0;
        public static const COLOR_DARK:uint = 0x333333;
        public static const COLOR_MEDIUM:uint = 0x777777;
        public static const COLOR_LIGHT2:uint = 0xaaaaaa;
        public static const COLOR_LIGHT:uint = 0xf7f7f7;
        public static const COLOR_WHITE:uint = 0xffffff;
        
        public static const TAKE_OVER_COLOR:uint = COLOR_DARK;
        public static const TAKE_OVER_ALPHA:Number = .8;
        
        public static function drawGradient(g:Graphics, width:Number, height:Number):void
        {
            g.clear();
            var matr:Matrix = new Matrix();
            matr.createGradientBox( width, height, Math.PI*.5, 0, 0 );
            g.beginGradientFill( GradientType.LINEAR, [ COLOR_LIGHT,COLOR_LIGHT2 ], [ 1, 1], [ 0, 255 ], matr, SpreadMethod.PAD );
            g.drawRect( 0, 0, width, height );
        }

    }
}