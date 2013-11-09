unit DyspozytorskaRegulaHarmonogramowaniaSPTO;

interface

uses
  DyspozytorskaRegulaHarmonogramowania, Etapy, ZlecenieEtap;

type
  TDyspozytorskaRegulaHarmonogramowaniaSPTO = class(TDyspozytorskaRegulaHarmonogramowania)
  public
    function WybierzZEtapy(etapy : TEtapy) : TZlecenieEtap; override;
    function NazwaReguly() : String; override;
  end;

implementation

  function TDyspozytorskaRegulaHarmonogramowaniaSPTO.WybierzZEtapy(etapy: TEtapy) : TZlecenieEtap;
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

  function TDyspozytorskaRegulaHarmonogramowaniaSPTO.NazwaReguly;
  begin
    Result := 'SPT dla operacji';
  end;

end.
