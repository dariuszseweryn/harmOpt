unit DyspozytorskaRegulaHarmonogramowaniaSCRW;

interface

uses
  DyspozytorskaRegulaHarmonogramowania, Etapy, ZlecenieEtap;

type
  TDyspozytorskaRegulaHarmonogramowaniaSCRW = class(TDyspozytorskaRegulaHarmonogramowania)
  public
    function WybierzZEtapy(etapy : TEtapy) : TZlecenieEtap; override;
    function NazwaReguly() : String; override;
  end;

implementation

  function TDyspozytorskaRegulaHarmonogramowaniaSCRW.WybierzZEtapy(etapy: TEtapy) : TZlecenieEtap;
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
        resultCR := (Result.daneZlecenia.PLAN_TERMIN_REALIZACJI - Result.DataProponowana) / (CzasHelper.DataCzasZakonczeniaDlaDatyCzasuStartuICzasuTrwania(Result.DataProponowana, PozostalyCzasWykonaniaNettoWyrobu(Result)) - Result.DataProponowana);
        etapCR := (etapZlecenia.daneZlecenia.PLAN_TERMIN_REALIZACJI - etapZlecenia.DataProponowana) / (CzasHelper.DataCzasZakonczeniaDlaDatyCzasuStartuICzasuTrwania(etapZlecenia.DataProponowana, PozostalyCzasWykonaniaNettoWyrobu(etapZlecenia)) - etapZlecenia.DataProponowana);
        if (resultCR > etapCR) then
          Result := etapZlecenia;
      end;
    end;
  end;

  function TDyspozytorskaRegulaHarmonogramowaniaSCRW.NazwaReguly;
  begin
    Result := 'SCR dla wyrobu';
  end;

end.
