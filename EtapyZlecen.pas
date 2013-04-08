unit EtapyZlecen;

interface

uses
  EtapZlecenia;

type
  TEtapyZlecen = class

    private
    function numerEtapuPoprzedzajacegoEtap(etapZlecenia : TEtapZlecenia) : Integer;
    function indeksEtapuDla(NR_ETAPU, ID_ZLECENIA : Integer) : Integer;

    public
    var
      Etapy : Array of TEtapZlecenia;

    destructor Free;
    procedure dodajEtap(etapZlecenia : TEtapZlecenia);
    function indeksEtapuPoprzedzajacegoEtap(etapZlecenia : TEtapZlecenia) : Integer;
  end;

implementation

  destructor TEtapyZlecen.Free;
  var
    EtapZlecenia : TEtapZlecenia;
  begin
    for EtapZlecenia in Etapy do EtapZlecenia.Free;
    SetLength(Etapy,0);
  end;

  procedure TEtapyZlecen.dodajEtap(etapZlecenia : TEtapZlecenia);
  begin
    SetLength(Etapy, Length(Etapy) + 1);
    Etapy[Length(Etapy) - 1] := etapZlecenia;
  end;

  function TEtapyZlecen.indeksEtapuPoprzedzajacegoEtap(etapZlecenia : TEtapZlecenia) : Integer;
  var
    numerEtapuPoprzedzajacego : Integer;
  begin
    numerEtapuPoprzedzajacego := numerEtapuPoprzedzajacegoEtap(etapZlecenia);
    Result := indeksEtapuDla(numerEtapuPoprzedzajacego, etapZlecenia.ID_ZLECENIA);
  end;

  // private

  function TEtapyZlecen.numerEtapuPoprzedzajacegoEtap(etapZlecenia : TEtapZlecenia) : Integer;
  var
    etapZleceniaTemp : TEtapZlecenia;
    warunek : Boolean;
  begin
    Result := -1;
    warunek := etapZlecenia.NR_ETAPU > 0;
    if warunek then
    begin
      for etapZleceniaTemp in Etapy do
      begin
        warunek := etapZleceniaTemp.ID_ZLECENIA = etapZlecenia.ID_ZLECENIA;
        if warunek then
        begin
          warunek := (etapZleceniaTemp.NR_ETAPU > Result) and (etapZleceniaTemp.NR_ETAPU < etapZlecenia.NR_ETAPU);
          if warunek then Result := etapZleceniaTemp.NR_ETAPU;
        end;
      end;
    end;
  end;

  function TEtapyZlecen.indeksEtapuDla(NR_ETAPU, ID_ZLECENIA : Integer) : Integer;
  var
    I : Integer;
    etapZleceniaTemp : TEtapZlecenia;
    warunek : Boolean;
  begin
    Result := -1;
    warunek := (NR_ETAPU >= 0) and (ID_ZLECENIA > 0);
    if warunek then
    begin
      I := 0;
      for etapZleceniaTemp in Etapy do
      begin
        warunek := (etapZleceniaTemp.ID_ZLECENIA = ID_ZLECENIA)
                    and (etapZleceniaTemp.NR_ETAPU = NR_ETAPU);

        if warunek then
        begin
          Result := I;
          break;
        end;

        I := I + 1;
      end;
    end;
  end;

end.
