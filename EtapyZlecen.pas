unit EtapyZlecen;

interface

uses
  EtapZlecenia;

type
  TEtapyZlecen = class

    public
    var
      ArrayEZ : Array of TEtapZlecenia;

    destructor Free;
    procedure dodajEtap(etapZlecenia : TEtapZlecenia);
  end;

implementation

  destructor TEtapyZlecen.Free;
  var
    EtapZlecenia : TEtapZlecenia;
    I: Integer;
  begin
    if Length(self.ArrayEZ) > 0 then
    begin
      for I := 0 to Length(self.ArrayEZ) do
      begin
        EtapZlecenia := self.ArrayEZ[I];
        EtapZlecenia.Free;
      end;

      SetLength(self.ArrayEZ,0);
    end;
  end;

  procedure TEtapyZlecen.dodajEtap(etapZlecenia : TEtapZlecenia);
  begin
    SetLength(self.ArrayEZ, Length(self.ArrayEZ) + 1);
    self.ArrayEZ[Length(self.ArrayEZ) - 1] := etapZlecenia;
  end;

end.
