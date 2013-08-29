unit DyspozytorskaRegulaHarmonogramowaniaSCR;

interface

uses
  DyspozytorskaRegulaHarmonogramowania, Etapy, ZlecenieEtap;

type
  TDyspozytorskaRegulaHarmonogramowaniaSCR = class(TDyspozytorskaRegulaHarmonogramowania)
  public
    function WybierzZEtapy(etapy : TEtapy) : TZlecenieEtap; override;
    function NazwaReguly() : String; override;
  end;

implementation

  function TDyspozytorskaRegulaHarmonogramowaniaSCR.WybierzZEtapy(etapy: TEtapy) : TZlecenieEtap;
  var
    etapZlecenia : TZlecenieEtap;
    resultCR, etapCR : TDateTime;
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
        resultCR := (Result.daneZlecenia.PLAN_TERMIN_REALIZACJI - Result.DataProponowana) / CzasHelper.DataCzasZakonczeniaDlaDatyCzasuStartuICzasuTrwania(Result.DataProponowana, PozostalyCzasWykonaniaNettoWyrobu(Result));
        etapCR := (etapZlecenia.daneZlecenia.PLAN_TERMIN_REALIZACJI - etapZlecenia.DataProponowana) / CzasHelper.DataCzasZakonczeniaDlaDatyCzasuStartuICzasuTrwania(etapZlecenia.DataProponowana, PozostalyCzasWykonaniaNettoWyrobu(etapZlecenia));
        if (resultCR > etapCR) then
          Result := etapZlecenia;
      end;
    end;
  end;

  function TDyspozytorskaRegulaHarmonogramowaniaSCR.NazwaReguly;
  begin
    Result := 'SCR';
  end;

end.
