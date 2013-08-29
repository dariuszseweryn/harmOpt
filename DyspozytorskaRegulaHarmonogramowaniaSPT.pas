unit DyspozytorskaRegulaHarmonogramowaniaSPT;

interface

uses
  DyspozytorskaRegulaHarmonogramowania, Etapy, ZlecenieEtap;

type
  TDyspozytorskaRegulaHarmonogramowaniaSPT = class(TDyspozytorskaRegulaHarmonogramowania)
  public
    function WybierzZEtapy(etapy : TEtapy) : TZlecenieEtap; override;
    function NazwaReguly() : String; override;
  end;

implementation

  function TDyspozytorskaRegulaHarmonogramowaniaSPT.WybierzZEtapy(etapy: TEtapy) : TZlecenieEtap;
  var
    etapZlecenia : TZlecenieEtap;
  begin
    Result := nil;
    for etapZlecenia in etapy do
    begin
      if Result = nil then Result := etapZlecenia
      else if (Result.CzasWykonaniaNetto > etapZlecenia.CzasWykonaniaNetto) then
        Result := etapZlecenia;
    end;
  end;

  function TDyspozytorskaRegulaHarmonogramowaniaSPT.NazwaReguly;
  begin
    Result := 'SPT';
  end;

end.
