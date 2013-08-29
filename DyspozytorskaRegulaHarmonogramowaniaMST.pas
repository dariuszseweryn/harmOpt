unit DyspozytorskaRegulaHarmonogramowaniaMST;

interface

uses
  DyspozytorskaRegulaHarmonogramowania, Etapy, ZlecenieEtap;

type
  TDyspozytorskaRegulaHarmonogramowaniaMST = class(TDyspozytorskaRegulaHarmonogramowania)
  public
    function WybierzZEtapy(etapy : TEtapy) : TZlecenieEtap; override;
    function NazwaReguly() : String; override;
  end;

implementation

  function TDyspozytorskaRegulaHarmonogramowaniaMST.WybierzZEtapy(etapy: TEtapy) : TZlecenieEtap;
  var
    etapZlecenia : TZlecenieEtap;
    resultST, etapST : TDateTime;
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
        resultST := Result.daneZlecenia.PLAN_TERMIN_REALIZACJI - CzasHelper.DataCzasZakonczeniaDlaDatyCzasuStartuICzasuTrwania(Result.DataProponowana, PozostalyCzasWykonaniaNettoWyrobu(Result));
        etapST := etapZlecenia.daneZlecenia.PLAN_TERMIN_REALIZACJI - CzasHelper.DataCzasZakonczeniaDlaDatyCzasuStartuICzasuTrwania(etapZlecenia.DataProponowana, PozostalyCzasWykonaniaNettoWyrobu(etapZlecenia));
        if (resultST > etapST) then
          Result := etapZlecenia;
      end;
    end;
  end;

  function TDyspozytorskaRegulaHarmonogramowaniaMST.NazwaReguly;
  begin
    Result := 'MST';
  end;

end.
