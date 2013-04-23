unit KolorHelper;

interface

uses
  Vcl.Graphics, System.Generics.Collections;

type
  TKolorHelper = class
    private
      kolory : TList<TColor>;
      ids : TList<Integer>;
      procedure WypelnijKolory;
    public
      constructor Create;
      destructor Free;
      function KolorDlaId(id : Integer) : TColor;
  end;

implementation

  // private

  procedure TKolorHelper.WypelnijKolory;
  begin
    kolory.Add(clRed);
    kolory.Add(clYellow);
    kolory.Add(clBlue);
    kolory.Add(clGreen);
    kolory.Add(clPurple);
    kolory.Add(clTeal);
    kolory.Add(clFuchsia);
    kolory.Add(clLime);
    kolory.Add(clMoneyGreen);
    kolory.Add(clNavy);
    kolory.Add(clSkyBlue);
    kolory.Add(clOlive);
    kolory.Add(clAqua);
    kolory.Add(clMaroon);
    kolory.Add(clWhite);
    kolory.Add(clWebDeepPink);
    kolory.Add(clWebDarkSlateBlue);
    kolory.Add(clWebRosyBrown);
    kolory.Add(clWebIndigo);
    kolory.Add(clWebDarkGoldenRod);
  end;

  // public

  constructor TKolorHelper.Create;
  begin
    kolory := TList<TColor>.Create;
    ids := TList<Integer>.Create;
    WypelnijKolory;
  end;

  destructor TKolorHelper.Free;
  begin
    kolory.Free;
    ids.Free;
  end;

  function TKolorHelper.KolorDlaId(id: Integer) : TColor;
  var
    tmpId : Integer;
    I : Integer;
  begin
    I := ids.IndexOf(id);
    if I = -1 then I := ids.Add(id);
    while I > kolory.Count -1 do I := I - kolory.Count;
    Result := kolory.Items[I];
  end;

end.
