unit DyspozytorskaRegulaHarmonogramowaniaMDD;

interface

uses
  DyspozytorskaRegulaHarmonogramowania, Etapy, ZlecenieEtap, Math;

type
  TDyspozytorskaRegulaHarmonogramowaniaMDD = class(TDyspozytorskaRegulaHarmonogramowania)
  public
    function WybierzZEtapy(etapy : TEtapy) : TZlecenieEtap; override;
    function NazwaReguly() : String; override;
  end;

implementation

  function TDyspozytorskaRegulaHarmonogramowaniaMDD.WybierzZEtapy(etapy: TEtapy) : TZlecenieEtap;
  var
    etapZlecenia : TZlecenieEtap;
    resultMDD, etapZleceniaMDD : TDateTime;
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
        resultMDD := Max(CzasHelper.DataCzasZakonczeniaDlaDatyCzasuStartuICzasuTrwania(Result.DataProponowana, PozostalyCzasWykonaniaNettoWyrobu(Result)), Result.daneZlecenia.PLAN_TERMIN_REALIZACJI);
        etapZleceniaMDD := Max(CzasHelper.DataCzasZakonczeniaDlaDatyCzasuStartuICzasuTrwania(etapZlecenia.DataProponowana, PozostalyCzasWykonaniaNettoWyrobu(etapZlecenia)), etapZlecenia.daneZlecenia.PLAN_TERMIN_REALIZACJI);
        if (resultMDD > etapZleceniaMDD) then
          Result := etapZlecenia;
      end;
    end;
  end;

  function TDyspozytorskaRegulaHarmonogramowaniaMDD.NazwaReguly;
  begin
    Result := 'MDD';
  end;

end.
