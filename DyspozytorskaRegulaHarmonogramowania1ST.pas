unit DyspozytorskaRegulaHarmonogramowania1ST;

interface

uses
  DyspozytorskaRegulaHarmonogramowania, Etapy, ZlecenieEtap;

type
  TDyspozytorskaRegulaHarmonogramowania1ST = class(TDyspozytorskaRegulaHarmonogramowania)
  public
    function WybierzZEtapy(etapy : TEtapy) : TZlecenieEtap; override;
    function NazwaReguly() : String; override;
  end;

implementation

  function TDyspozytorskaRegulaHarmonogramowania1ST.WybierzZEtapy(etapy: TEtapy) : TZlecenieEtap;
  var
    etapZlecenia : TZlecenieEtap;
  begin
    Result := etapy[0];
  end;

  function TDyspozytorskaRegulaHarmonogramowania1ST.NazwaReguly;
  begin
    Result := 'Pierwsza';
  end;

end.
