unit MyButton;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Graphics, Winapi.Windows,
  Winapi.Messages;

type
  TTextItem = class(TCollectionItem)
  private
    FText1: string;
    FText2: string;
    FX: Integer;
    FY: Integer;
    procedure SetText1(const Value: string);
    procedure SetText2(const Value: string);
    procedure SetX(const Value: Integer);
    procedure SetY(const Value: Integer);
    function GetText1: string;
    function GetText2: string;
    function GetX: Integer;
    function GetY: Integer;
  public
    function ToString: string; override;
  published
    property Text1: string read GetText1 write SetText1;
    property Text2: string read GetText2 write SetText2;
    property X: Integer read GetX write SetX;
    property Y: Integer read GetY write SetY;
  end;

  TMyButton = class(TGraphicControl)
  private
    FMainCaption: string;
    FCaptionLists: TCollection;
    FMouseInControl: Boolean;
    procedure SetMainCaption(const Value: string);
    function GetMainCaption: string;
    procedure SetCaptionLists(const Value: TCollection);
    procedure MouseEnter(Sender: TObject);
    procedure MouseLeave(Sender: TObject);
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property MainCaption: string read GetMainCaption write SetMainCaption;
    property CaptionLists: TCollection read FCaptionLists write SetCaptionLists;
  end;

procedure Register;

implementation

{ TTextItem }

function TTextItem.GetText1: string;
begin
  Result := FText1;
end;

function TTextItem.GetText2: string;
begin
  Result := FText2;
end;

function TTextItem.GetX: Integer;
begin
  Result := FX;
end;

function TTextItem.GetY: Integer;
begin
  Result := FY;
end;

procedure TTextItem.SetX(const Value: Integer);
begin
  FX := Value;
end;

procedure TTextItem.SetY(const Value: Integer);
begin
  FY := Value;
end;

procedure TTextItem.SetText1(const Value: string);
begin
  FText1 := Value;
end;

procedure TTextItem.SetText2(const Value: string);
begin
  FText2 := Value;
end;

function TTextItem.ToString: string;
begin
  Result := Format('%s, %s (%d, %d)', [Text1, Text2, X, Y]);
end;

{ TMyButton }

constructor TMyButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FCaptionLists := TCollection.Create(TTextItem);
  with TTextItem(FCaptionLists.Add) do
  begin
    Text1 := 'Default Text 1';
    Text2 := 'Default Text 2';
  end;
  Width := 100;
  Height := 30;
  FMouseInControl := False;
  Cursor := crHandPoint;
  OnMouseEnter := MouseEnter;
  OnMouseLeave := MouseLeave;
end;

destructor TMyButton.Destroy;
begin
  FCaptionLists.Free;
  inherited;
end;

function TMyButton.GetMainCaption: string;
begin
  Result := FMainCaption;
end;

procedure TMyButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Button = mbLeft then
    Canvas.Font.Color := clHighlight;
  Invalidate;
end;

procedure TMyButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Button = mbLeft then
    Canvas.Font.Color := clBtnText;
  Invalidate;
end;

procedure TMyButton.MouseEnter(Sender: TObject);
begin
  FMouseInControl := True;
  Invalidate;
end;

procedure TMyButton.MouseLeave(Sender: TObject);
begin
  FMouseInControl := False;
  Invalidate;
end;

procedure TMyButton.Paint;
var
  I: Integer;
  TextItem: TTextItem;
  TextRect: TRect;
begin
  inherited;
  if FMouseInControl then
    Canvas.Brush.Color := clBtnFace
  else
    Canvas.Brush.Color := clWindow;
  Canvas.FillRect(ClientRect);
  for I := 0 to FCaptionLists.Count - 1 do
  begin
    TextItem := TTextItem(FCaptionLists.Items[I]);
    TextRect := Rect(TextItem.X, TextItem.Y, ClientWidth, ClientHeight);
    Canvas.Font := Self.Font;
    TextRect.Top := TextRect.Top + TextItem.Y;
    TextRect.Left := TextRect.Left + TextItem.X;
    DrawText(Canvas.Handle, PChar(TextItem.Text1), Length(TextItem.Text1), TextRect, DT_LEFT or DT_TOP or DT_SINGLELINE or DT_END_ELLIPSIS);
  end;
end;



procedure TMyButton.SetCaptionLists(const Value: TCollection);
begin
  FCaptionLists.Assign(Value);
end;

procedure TMyButton.SetMainCaption(const Value: string);
var
  TextItem: TTextItem;
begin
  FMainCaption := Value;
  Caption := FMainCaption;
  if FCaptionLists.Count > 0 then
  begin
    TextItem := TTextItem(FCaptionLists.Items[0]);
    TextItem.Text1 := FMainCaption;
  end;
end;

procedure Register;
begin
  RegisterComponents('Samples', [TMyButton]);
end;

end.

