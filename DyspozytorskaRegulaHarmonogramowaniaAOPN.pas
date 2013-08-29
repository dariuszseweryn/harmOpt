unit DyspozytorskaRegulaHarmonogramowaniaAOPN;

interface

uses
  DyspozytorskaRegulaHarmonogramowania, Etapy, ZlecenieEtap;

type
  TDyspozytorskaRegulaHarmonogramowaniaAOPN = class(TDyspozytorskaRegulaHarmonogramowania)
  public
    function WybierzZEtapy(etapy : TEtapy) : TZlecenieEtap; override;
    function NazwaReguly() : String; override;
  end;

implementation

  function TDyspozytorskaRegulaHarmonogramowaniaAOPN.WybierzZEtapy(etapy: TEtapy) : TZlecenieEtap;
  var
    etapZlecenia : TZlecenieEtap;
    resultOPN, etapOPN : TDateTime;
  begin
    Result := nil;
    etapZlecenia := nil;
    for etapZlecenia in etapy do
    begin
      if Result = nil then
      begin
        Result := etapZlecenia;
      end
      else
      begin
        resultOPN := (Result.daneZlecenia.PLAN_TERMIN_REALIZACJI - Result.DataProponowana) / IloscPozostalychOperacji(Result);
        etapOPN := (etapZlecenia.daneZlecenia.PLAN_TERMIN_REALIZACJI - etapZlecenia.DataProponowana) / IloscPozostalychOperacji(etapZlecenia);
        if (resultOPN > etapOPN) then
          Result := etapZlecenia;
      end;
    end;
  end;

  function TDyspozytorskaRegulaHarmonogramowaniaAOPN.NazwaReguly;
  begin
    Result := 'A/OPN';
  end;

end.
