unit FMX.Graphics.Helper;

interface

uses
  System.Types,
  FMX.Graphics;

type
  TCanvasHelper = class helper for TCanvas
    // 图片四角张缩
    procedure DrawBitmapCapInsets(const Bitmap1: TBitmap; // 图片
      const DesRect: TRectF; // 目的区域
      const CapInsetsRect: TRectF; // 四角区域
      const Opacity: Single = 1.0; // 透明度
      const HighSpeed: Boolean = False;
      const AScale: Single = 1.0);// 高速

    procedure DrawBitmapCapInsets1(const Bitmap1: TBitmap;
      const ARect: TRectF;
      const CapInsetsRect: TRectF;
      const AOpacity: Single = 1.0);
  end;

implementation

// 图片四角张缩
procedure TCanvasHelper.DrawBitmapCapInsets1(const Bitmap1: TBitmap;
  const ARect, CapInsetsRect: TRectF;
  const AOpacity: Single);
var
  AlignedRect, LR, LRUnscaled, R, IntersectionRect, UnscaledMargins: TRectF;
  SR, SRScaled: TRectF;
  ScreenScale: Single;
  HorzMarginsOnly, VertMarginsOnly: Boolean;
  DrawingScale: TPointF;
begin

  SR := TRectF.Create(0, 0, Bitmap1.width, Bitmap1.height);
  if SR.IsEmpty then
    Exit;

  ScreenScale := Self.Scale;

  //Self.Blending := False;

  SRScaled := TRectF.Create(SR.Left / ScreenScale, SR.Top / ScreenScale, SR.Right / ScreenScale, SR.Bottom / ScreenScale);

  AlignedRect := ARect;

  LR := TRectF.Create(AlignedRect.Left * ScreenScale, AlignedRect.Top * ScreenScale, AlignedRect.Right * ScreenScale, AlignedRect.Bottom * ScreenScale);
  LRUnscaled := AlignedRect;

  UnscaledMargins := TRectF.Create(CapInsetsRect.Left / ScreenScale, CapInsetsRect.Top / ScreenScale,
    CapInsetsRect.Right / ScreenScale, CapInsetsRect.Bottom / ScreenScale);

  if (CapInsetsRect.Left + CapInsetsRect.Right > LR.Width) then
  begin
    LR.Width := CapInsetsRect.Left + CapInsetsRect.Right;
    LRUnscaled.Width := LR.Width / ScreenScale;
    HorzMarginsOnly := True;
  end
  else
    HorzMarginsOnly := False;
  if (CapInsetsRect.Top + CapInsetsRect.Bottom > LR.Height) then
  begin
    LR.Height := CapInsetsRect.Top + CapInsetsRect.Bottom;
    LRUnscaled.Height := LR.Height / ScreenScale;
    VertMarginsOnly := True;
  end
  else
    VertMarginsOnly := False;

  // fixed scale
  {
  if HorzMarginsOnly or VertMarginsOnly then
  begin
    SaveState := Canvas.SaveState;
    Canvas.IntersectClipRect(ARect);
    // Offset for bottom oriented
    if VertMarginsOnly and (ParentControl <> nil) and (Position.Y + Height > ParentControl.Height / 2) then
    begin
      M := TMatrix.Identity;
      M.m32 := Height - LRUnscaled.Height;
      M := AbsoluteMatrix * M;
      Canvas.SetMatrix(M);
    end;
  end
  else
    SaveState := nil;
  }
  { lefttop }
  R := TRectF.Create(LRUnscaled.Left, LRUnscaled.Top, LRUnscaled.Left + UnscaledMargins.Left, LRUnscaled.Top + UnscaledMargins.Top);
  Self.DrawBitmap(Bitmap1, TRectF.Create(SR.Left, SR.Top, SR.Left + CapInsetsRect.Left, SR.Top + CapInsetsRect.Top), R,
    AOpacity, True);
  { righttop }
  R := TRectF.Create(LRUnscaled.Right - UnscaledMargins.Right, LRUnscaled.Top, LRUnscaled.Right, LRUnscaled.Top + UnscaledMargins.Top);
  Self.DrawBitmap(Bitmap1, TRectF.Create(SR.Right - CapInsetsRect.Right, SR.Top, SR.Right,
    SR.Top + CapInsetsRect.Top), R, AOpacity, True);
  { leftbottom }
  R := TRectF.Create(LRUnscaled.Left, LRUnscaled.Bottom - UnscaledMargins.Bottom, LRUnscaled.Left + UnscaledMargins.Left, LRUnscaled.Bottom);
  Self.DrawBitmap(Bitmap1, TRectF.Create(SR.Left, SR.Bottom - CapInsetsRect.Bottom,
    SR.Left + CapInsetsRect.Left, SR.Bottom), R, AOpacity, True);
  { rightbottom }
  R := TRectF.Create(LRUnscaled.Right - UnscaledMargins.Right, LRUnscaled.Bottom - UnscaledMargins.Bottom, LRUnscaled.Right, LRUnscaled.Bottom);
  Self.DrawBitmap(Bitmap1, TRectF.Create(SR.Right - CapInsetsRect.Right,
    SR.Bottom - CapInsetsRect.Bottom, SR.Right, SR.Bottom), R,
    AOpacity, True);
  if not HorzMarginsOnly then
  begin
    { top }
    Self.DrawBitmap(Bitmap1, TRectF.Create(SR.Left + CapInsetsRect.Left, SR.Top, SR.Right - CapInsetsRect.Right, SR.Top + CapInsetsRect.Top),
      TRectF.Create(LRUnscaled.Left + UnscaledMargins.Left, LRUnscaled.Top, LRUnscaled.Right - UnscaledMargins.Right, LRUnscaled.Top + UnscaledMargins.Top),
      AOpacity, True);
    { bottom }
    Self.DrawBitmap(Bitmap1, TRectF.Create(SR.Left + CapInsetsRect.Left, SR.Bottom - CapInsetsRect.Bottom, SR.Right - CapInsetsRect.Right, SR.Bottom),
      TRectF.Create(LRUnscaled.Left + UnscaledMargins.Left, LRUnscaled.Bottom - UnscaledMargins.Bottom, LRUnscaled.Right - UnscaledMargins.Right, LRUnscaled.Bottom),
      AOpacity, True);
  end;
  if not VertMarginsOnly then
  begin
    { left }
    Self.DrawBitmap(Bitmap1, TRectF.Create(SR.Left, SR.Top + CapInsetsRect.Top, SR.Left + CapInsetsRect.Left, SR.Bottom - CapInsetsRect.Bottom),
      TRectF.Create(LRUnscaled.Left, LRUnscaled.Top + UnscaledMargins.Top, LRUnscaled.Left + UnscaledMargins.Left, LRUnscaled.Bottom - UnscaledMargins.Bottom), AOpacity, True);
    { right }
    Self.DrawBitmap(Bitmap1, TRectF.Create(SR.Right - CapInsetsRect.Right, SR.Top + CapInsetsRect.Top, SR.Right, SR.Bottom - CapInsetsRect.Bottom),
      TRectF.Create(LRUnscaled.Right - UnscaledMargins.Right, LRUnscaled.Top + UnscaledMargins.Top, LRUnscaled.Right, LRUnscaled.Bottom - UnscaledMargins.Bottom),
      AOpacity, True);
  end;
  { center }
  if not VertMarginsOnly and not HorzMarginsOnly then
  begin
    R := TRectF.Create(LRUnscaled.Left + UnscaledMargins.Left, LRUnscaled.Top + UnscaledMargins.Top, LRUnscaled.Right - UnscaledMargins.Right, LRUnscaled.Bottom - UnscaledMargins.Bottom);
    Self.DrawBitmap(Bitmap1, TRectF.Create(SR.Left + CapInsetsRect.Left, SR.Top + CapInsetsRect.Top, SR.Right - CapInsetsRect.Right, SR.Bottom - CapInsetsRect.Bottom),
      R, AOpacity, True);
  end;
  //Self.Blending := True;
end;

procedure TCanvasHelper.DrawBitmapCapInsets(const Bitmap1: TBitmap; // 图片
  const DesRect: TRectF; // 目的区域
  const CapInsetsRect: TRectF; // 四角区域
  const Opacity: Single = 1.0; // 透明度
  const HighSpeed: Boolean = False;   // 高速
  const AScale: Single = 1.0);
var
  SrcRect: TRectF;
begin
  SrcRect := RectF(0, 0, Bitmap1.Width, Bitmap1.Height);
  // -------------------------------------------------------------------------
  // 最内圈 (不张缩)                                                        -
  // -------------------------------------------------------------------------
  // 左上
  Self.DrawBitmap(Bitmap1, RectF(SrcRect.Left, SrcRect.Top,
    SrcRect.Left + CapInsetsRect.Left, SrcRect.Top + CapInsetsRect.Top),
    RectF(DesRect.Left, DesRect.Top, DesRect.Left + CapInsetsRect.Left,
    DesRect.Top + CapInsetsRect.Left), Opacity, HighSpeed);

  // 右上
  Self.DrawBitmap(Bitmap1, RectF(SrcRect.Right - CapInsetsRect.Right*AScale,
    SrcRect.Top, SrcRect.Right, SrcRect.Top + CapInsetsRect.Top*AScale),
    RectF(DesRect.Right - CapInsetsRect.Right, DesRect.Top, DesRect.Right,
    DesRect.Top + CapInsetsRect.Top), Opacity, HighSpeed);

  // 左下
  Self.DrawBitmap(Bitmap1, RectF(SrcRect.Left,
    SrcRect.Bottom - CapInsetsRect.Bottom*AScale, SrcRect.Left + CapInsetsRect.Left*AScale,
    SrcRect.Bottom), RectF(DesRect.Left, DesRect.Bottom - CapInsetsRect.Bottom,
    DesRect.Left + CapInsetsRect.Left, DesRect.Bottom), Opacity, HighSpeed);

  // 右下
  Self.DrawBitmap(Bitmap1, RectF(SrcRect.Right - CapInsetsRect.Right*AScale,
    SrcRect.Bottom - CapInsetsRect.Bottom*AScale, SrcRect.Right, SrcRect.Bottom),
    RectF(DesRect.Right - CapInsetsRect.Right,
    DesRect.Bottom - CapInsetsRect.Bottom, DesRect.Right, DesRect.Bottom),
    Opacity, HighSpeed);

  // 左
  Self.DrawBitmap(Bitmap1, RectF(SrcRect.Left, SrcRect.Top + CapInsetsRect.Top*AScale,
    SrcRect.Left + CapInsetsRect.Left*AScale, SrcRect.Bottom - CapInsetsRect.Bottom*AScale),
    RectF(DesRect.Left, DesRect.Top + CapInsetsRect.Top,
    DesRect.Left + CapInsetsRect.Left, DesRect.Bottom - CapInsetsRect.Bottom),
    Opacity, HighSpeed);

  // 上
  Self.DrawBitmap(Bitmap1, RectF(SrcRect.Left + CapInsetsRect.Left*AScale, SrcRect.Top,
    SrcRect.Right - CapInsetsRect.Right*AScale, SrcRect.Top + CapInsetsRect.Top*AScale),
    RectF(DesRect.Left + CapInsetsRect.Left, DesRect.Top,
    DesRect.Right - CapInsetsRect.Right, DesRect.Top + CapInsetsRect.Top),
    Opacity, HighSpeed);

  // 右
  Self.DrawBitmap(Bitmap1, RectF(SrcRect.Right - CapInsetsRect.Right*AScale,
    SrcRect.Top + CapInsetsRect.Top*AScale, SrcRect.Right,
    SrcRect.Bottom - CapInsetsRect.Bottom*AScale),
    RectF(DesRect.Right - CapInsetsRect.Right, DesRect.Top + CapInsetsRect.Top,
    DesRect.Right, DesRect.Bottom - CapInsetsRect.Bottom), Opacity, HighSpeed);

  // 下
  Self.DrawBitmap(Bitmap1, RectF(SrcRect.Left + CapInsetsRect.Left*AScale,
    SrcRect.Bottom - CapInsetsRect.Bottom*AScale, SrcRect.Right - CapInsetsRect.Right*AScale,
    SrcRect.Bottom), RectF(DesRect.Left + CapInsetsRect.Left,
    DesRect.Bottom - CapInsetsRect.Bottom, DesRect.Right - CapInsetsRect.Right,
    DesRect.Bottom), Opacity, HighSpeed);

  // 中
  Self.DrawBitmap(Bitmap1, RectF(SrcRect.Left + CapInsetsRect.Left*AScale,
    SrcRect.Top + CapInsetsRect.Top*AScale, SrcRect.Right - CapInsetsRect.Right*AScale,
    SrcRect.Bottom - CapInsetsRect.Bottom*AScale),
    RectF(DesRect.Left + CapInsetsRect.Left, DesRect.Top + CapInsetsRect.Top,
    DesRect.Right - CapInsetsRect.Right, DesRect.Bottom - CapInsetsRect.Bottom),
    Opacity, HighSpeed);
end;

end.
