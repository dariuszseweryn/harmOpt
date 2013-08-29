unit DyspozytorskaRegulaHarmonogramowaniaSOPN;

interface

uses
  DyspozytorskaRegulaHarmonogramowania, Etapy, ZlecenieEtap;

type
  TDyspozytorskaRegulaHarmonogramowaniaSOPN = class(TDyspozytorskaRegulaHarmonogramowania)
  public
    function WybierzZEtapy(etapy : TEtapy) : TZlecenieEtap; override;
    function NazwaReguly() : String; override;
  end;

implementation

  function TDyspozytorskaRegulaHarmonogramowaniaSOPN.WybierzZEtapy(etapy: TEtapy) : TZlecenieEtap;
  var
    etapZlecenia : TZlecenieEtap;
    resultSOPN, etapSOPN : TDateTime;
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
        resultSOPN := (Result.daneZlecenia.PLAN_TERMIN_REALIZACJI - CzasHelper.DataCzasZakonczeniaDlaDatyCzasuStartuICzasuTrwania(Result.DataProponowana, Result.CzasWykonaniaNetto)) / IloscPozostalychOperacji(Result);
        etapSOPN := (etapZlecenia.daneZlecenia.PLAN_TERMIN_REALIZACJI - CzasHelper.DataCzasZakonczeniaDlaDatyCzasuStartuICzasuTrwania(etapZlecenia.DataProponowana, etapZlecenia.CzasWykonaniaNetto)) / IloscPozostalychOperacji(etapZlecenia);
        if (resultSOPN > etapSOPN) then
          Result := etapZlecenia;
      end;
    end;
  end;

  function TDyspozytorskaRegulaHarmonogramowaniaSOPN.NazwaReguly;
  begin
    Result := 'S/OPN';
  end;

end.
