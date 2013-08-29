unit DyspozytorskaRegulaHarmonogramowania;

interface

uses
  ZlecenieDane, ZlecenieEtap, Etapy, CzasHelper;

type
  TDyspozytorskaRegulaHarmonogramowania = class

  protected
  czasHelper : TCzasHelper;

  function PozostalyCzasWykonaniaNettoWyrobu(etapZlecenia : TZlecenieEtap) : Integer;
  function IloscPozostalychOperacji(etapZlecenia : TZlecenieEtap) : Integer;

  public
  constructor Create(czasHelperToUse : TCzasHelper);
  function WybierzZEtapy(etapy: TEtapy) : TZlecenieEtap; virtual; abstract;
  function NazwaReguly() : String; virtual; abstract;

  end;

implementation

  constructor TDyspozytorskaRegulaHarmonogramowania.Create(czasHelperToUse : TCzasHelper);
  begin
    czasHelper := czasHelperToUse;
  end;

  function TDyspozytorskaRegulaHarmonogramowania.PozostalyCzasWykonaniaNettoWyrobu(etapZlecenia : TZlecenieEtap) : Integer;
  var
    etapTemp : TZlecenieEtap;
  begin
    Result := etapZlecenia.CzasWykonaniaNetto();
    etapTemp := etapZlecenia;
    while not (etapTemp.nastepnyEtap = nil) do
    begin
      etapTemp := etapTemp.nastepnyEtap;
      Result := Result + etapTemp.CzasWykonaniaNetto();
    end;
  end;

  function TDyspozytorskaRegulaHarmonogramowania.IloscPozostalychOperacji(etapZlecenia : TZlecenieEtap) : Integer;
  var
    etapTemp : TZlecenieEtap;
  begin
    Result := 1;
    etapTemp := etapZlecenia;
    while not (etapTemp.nastepnyEtap = nil) do
    begin
      etapTemp := etapTemp.nastepnyEtap;
      Result := Result + 1;
    end;
  end;

end.
