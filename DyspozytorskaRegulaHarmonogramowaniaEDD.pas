unit DyspozytorskaRegulaHarmonogramowaniaEDD;

interface

uses
  DyspozytorskaRegulaHarmonogramowania, Etapy, ZlecenieEtap;

type
  TDyspozytorskaRegulaHarmonogramowaniaEDD = class(TDyspozytorskaRegulaHarmonogramowania)
  public
    function WybierzZEtapy(etapy : TEtapy) : TZlecenieEtap; override;
    function NazwaReguly() : String; override;
  end;

implementation

  function TDyspozytorskaRegulaHarmonogramowaniaEDD.WybierzZEtapy(etapy: TEtapy) : TZlecenieEtap;
  var
    etapZlecenia : TZlecenieEtap;
  begin
    Result := nil;
    etapZlecenia := nil;
    for etapZlecenia in etapy do
    begin
      if Result = nil then
      begin
        Result := etapZlecenia;
      end
      else if (Result.daneZlecenia.PLAN_TERMIN_REALIZACJI > etapZlecenia.daneZlecenia.PLAN_TERMIN_REALIZACJI) then
        Result := etapZlecenia;
    end;
  end;

  function TDyspozytorskaRegulaHarmonogramowaniaEDD.NazwaReguly;
  begin
    Result := 'EDD';
  end;

end.
