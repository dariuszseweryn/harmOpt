unit DyspozytorskaRegulaHarmonogramowaniaSPTW;

interface

uses
  DyspozytorskaRegulaHarmonogramowania, Etapy, ZlecenieEtap;

type
  TDyspozytorskaRegulaHarmonogramowaniaSPTW = class(TDyspozytorskaRegulaHarmonogramowania)
  public
    function WybierzZEtapy(etapy : TEtapy) : TZlecenieEtap; override;
    function NazwaReguly() : String; override;
  end;

implementation

  function TDyspozytorskaRegulaHarmonogramowaniaSPTW.WybierzZEtapy(etapy: TEtapy) : TZlecenieEtap;
  var
    etapZlecenia : TZlecenieEtap;
  begin
    Result := nil;
    for etapZlecenia in etapy do
    begin
      if Result = nil then Result := etapZlecenia
      else if (PozostalyCzasWykonaniaNettoWyrobu(Result) > PozostalyCzasWykonaniaNettoWyrobu(etapZlecenia)) then
        Result := etapZlecenia;
    end;
  end;

  function TDyspozytorskaRegulaHarmonogramowaniaSPTW.NazwaReguly;
  begin
    Result := 'SPT dla wyrobu';
  end;

end.
