unit CzasHelper;

interface

uses
  System.SysUtils, System.DateUtils;

type
  TCzasHelper = class
    private
      czasPracyWCiaguDnia : TDateTime;
      czasWolnyOdPracyWCiaguDnia : TDateTime;
      czasRozpoczeciaPracy : TDateTime;
      czasKoncaPracy : TDateTime;

      function PozaGodzinamiPracy(dataCzas : TDateTime) : Boolean;
      function TrwaPowyzejJednegoDniaRoboczego(czasWMinutach : Integer) : Boolean;
      function IloscDniWolnychPomiedzyDatami(nieruchomaData, ruchomaData : TDateTime) : Integer;
      function DzienWolny(dataCzas : TDateTime) : Boolean;

    public
      constructor Create(godzinaPoczatkuPracy, godzinaKoncaPracy : TDateTime);

      function DataCzasZakonczeniaDlaDatyCzasuStartuICzasuTrwania
        (start : TDateTime; czasTrwaniaWMinutach : Integer) : TDateTime;
      function DataCzasRozpoczeciaDlaDatyCzasuZakonczeniaICzasuTrwania
        (koniec : TDateTime; czasTrwaniaWMinutach : Integer) : TDateTime;
      function DataCzasPracujacy(dataCzas : TDateTime; pozniejsza : Boolean) : TDateTime;
  end;

implementation

  //private

  function TCzasHelper.PozaGodzinamiPracy(dataCzas : TDateTime) : Boolean;
  begin
    Result := (TimeOf(dataCzas) > TimeOf(czasKoncaPracy)) or (TimeOf(dataCzas) < TimeOf(czasRozpoczeciaPracy));
  end;

  function TCzasHelper.TrwaPowyzejJednegoDniaRoboczego(czasWMinutach : Integer) : Boolean;
  begin
    Result := IncMinute(EncodeTime(0,0,0,0), czasWMinutach) > czasPracyWCiaguDnia;
  end;

  function TCzasHelper.IloscDniWolnychPomiedzyDatami(nieruchomaData, ruchomaData : TDateTime) : Integer;
  var
    zmianaDnia : Integer;
    tempDateTime1 : TDateTime;
    tempDateTime2 : TDateTime;
  begin
    tempDateTime1 := DateOf(nieruchomaData);
    tempDateTime2 := DateOf(ruchomaData);
    Result := 0;

    if tempDateTime1 < tempDateTime2 then zmianaDnia := 1
    else zmianaDnia := -1;

    while ((not (tempDateTime1 = tempDateTime2)) or DzienWolny(tempDateTime2)) do
    begin
      if DzienWolny(tempDateTime1) then
      begin
        tempDateTime2 := IncDay(tempDateTime2, zmianaDnia);
        Result := Result + 1;
      end;
      tempDateTime1 := IncDay(tempDateTime1, zmianaDnia);
    end;
  end;

  function TCzasHelper.DzienWolny(dataCzas : TDateTime) : Boolean;
  begin
    Result := ((DayOfWeek(dataCzas) = 1) or (DayOfWeek(dataCzas) = 7));
  end;

  //public

  constructor TCzasHelper.Create(godzinaPoczatkuPracy, godzinaKoncaPracy : TDateTime);
  begin
    czasRozpoczeciaPracy := godzinaPoczatkuPracy;
    czasKoncaPracy := godzinaKoncaPracy;
    czasPracyWCiaguDnia := godzinaKoncaPracy - godzinaPoczatkuPracy;
    czasWolnyOdPracyWCiaguDnia := EncodeTime(23,0,0,0) + EncodeTime(1,0,0,0) - czasPracyWCiaguDnia;
  end;

  function TCzasHelper.DataCzasZakonczeniaDlaDatyCzasuStartuICzasuTrwania
        (start : TDateTime; czasTrwaniaWMinutach : Integer) : TDateTime;
  var
    roboczoDni : Integer;
  begin
    Result := IncMinute(start, czasTrwaniaWMinutach);

    if TrwaPowyzejJednegoDniaRoboczego(czasTrwaniaWMinutach) then
    begin
      roboczoDni := Trunc(IncMinute(EncodeTime(0,0,0,0), czasTrwaniaWMinutach) / czasPracyWCiaguDnia);
      Result := Result + roboczoDni * czasWolnyOdPracyWCiaguDnia;
    end;

    if PozaGodzinamiPracy(Result) then
    begin
      Result := Result + czasWolnyOdPracyWCiaguDnia;
    end;

    Result := IncDay(Result, IloscDniWolnychPomiedzyDatami(start, Result));
  end;

  function TCzasHelper.DataCzasRozpoczeciaDlaDatyCzasuZakonczeniaICzasuTrwania
        (koniec : TDateTime; czasTrwaniaWMinutach : Integer) : TDateTime;
  var
    roboczoDni : Integer;
  begin
    Result := IncMinute(koniec, -czasTrwaniaWMinutach);

    if TrwaPowyzejJednegoDniaRoboczego(czasTrwaniaWMinutach) then
    begin
      roboczoDni := Trunc(IncMinute(EncodeTime(0,0,0,0), czasTrwaniaWMinutach) / czasPracyWCiaguDnia);
      Result := Result + roboczoDni * -czasWolnyOdPracyWCiaguDnia;
    end;

    if PozaGodzinamiPracy(Result) then
    begin
      Result := Result - czasWolnyOdPracyWCiaguDnia;
    end;

    Result := IncDay(Result, -IloscDniWolnychPomiedzyDatami(koniec, Result));
  end;

  function TCzasHelper.DataCzasPracujacy(dataCzas : TDateTime; pozniejsza : Boolean) : TDateTime;
  var
    zmianaDnia : Integer;
    tempDataCzas : TDateTime;
  begin
    if pozniejsza then zmianaDnia := 1
    else zmianaDnia := -1;

    tempDataCzas := DateOf(dataCzas);
    Result := TimeOf(dataCzas);

    if pozniejsza then
      begin
        if TimeOf(dataCzas) < czasRozpoczeciaPracy then Result := czasRozpoczeciaPracy
        else if TimeOf(dataCzas) >= czasKoncaPracy then
          begin
            Result := czasRozpoczeciaPracy;
            tempDataCzas := IncDay(tempDataCzas, 1);
          end;
      end
    else
      begin
        if TimeOf(dataCzas) > czasKoncaPracy then Result := czasKoncaPracy
        else if TimeOf(dataCzas) <= czasRozpoczeciaPracy then
          begin
            Result := czasKoncaPracy;
            tempDataCzas := IncDay(tempDataCzas, 1);
          end;
      end;



    while DzienWolny(tempDataCzas) do tempDataCzas := IncDay(tempDataCzas, zmianaDnia);

    Result := Result + tempDataCzas;
  end;

end.
