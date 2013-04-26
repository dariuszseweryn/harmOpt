unit DataBaseHelper;

interface

uses
  System.SysUtils, System.Generics.Collections, Data.Win.ADODB,
  QueryHelper, Zlecenia, Zlecenie, ZlecenieEtap, Stanowiska, Stanowisko;

type
  TDataBaseHelper = class

  private
    procedure PrzygotujBazeDoZapisaniaHarmonogramowanychEtapow;
    procedure CofnijPrzygotowanieBazyDoZapisaniaHarmonogramowanychEtapow;

    function CzyKolumnaIstniejeWTabeli(nazwaKolumny, nazwaTabeli : String) : Boolean;
    procedure DodajKolumneDoTabeli(nazwaKolumny, nazwaTabeli, typDanych : String);
    procedure UsunKolumneZTabeli(nazwaKolumny, nazwaTabeli : String);
    { Private declarations }
  public
    { Public declarations }
    constructor Create(connection : TADOConnection);
//    destructor Free;

    function WyciagnijZleceniaDoHarmonogramowania(wprzod : Boolean) : TZlecenia;
    function WyciagnijStanowiskaDoHarmonogramowania : TStanowiska;

  end;

var
  Query1 : TQueryHelper;
  Query2 : TQueryHelper;

implementation

  constructor TDataBaseHelper.Create(connection : TADOConnection);
  begin
    Query1 := TQueryHelper.HelperWithConnection(connection);
    Query2 := TQueryHelper.HelperWithConnection(connection);
  end;

//  destructor TDataBaseHelper.Free;
//  begin
//    Query1.Free;
//    Query2.Free;
//  end;

  procedure TDataBaseHelper.PrzygotujBazeDoZapisaniaHarmonogramowanychEtapow;
  begin

  end;

  procedure TDataBaseHelper.CofnijPrzygotowanieBazyDoZapisaniaHarmonogramowanychEtapow;
  begin

  end;

  function TDataBaseHelper.CzyKolumnaIstniejeWTabeli(nazwaKolumny, nazwaTabeli : String) : Boolean;
  begin
    Query1.fetchQuery('SELECT * FROM '+ nazwaTabeli);

    if Query1.Query.FieldList.Find(nazwaKolumny) = nil
    then Result := False
    else Result := True;
  end;

  procedure TDataBaseHelper.DodajKolumneDoTabeli(nazwaKolumny, nazwaTabeli, typDanych : String);
  begin
    Query1.executeQuery('ALTER TABLE '+ nazwaTabeli + ' '+
                           'ADD '+ nazwaKolumny + ' ' + typDanych);
  end;

  procedure TDataBaseHelper.UsunKolumneZTabeli(nazwaKolumny, nazwaTabeli : String);
  begin
    Query1.executeQuery('ALTER TABLE '+ nazwaTabeli + ' '+
                           'DROP COLUMN '+ nazwaKolumny);
  end;

  function TDataBaseHelper.WyciagnijZleceniaDoHarmonogramowania(wprzod : Boolean) : TZlecenia;
  var
    zlecenia : TZlecenia;
    zlecenie : TZlecenie;
    etapZlecenia : TZlecenieEtap;
    ID_ZLEC_TECHNOLOGIE : Integer;
    poprzedniEtapZlecenia : TZlecenieEtap;
    sortowanie : String;
  begin
    if wprzod then sortowanie := 'asc'
    else sortowanie := 'desc';

    zlecenia := TZlecenia.Create(True);
    Query1.fetchQuery('SELECT * '+
                             'FROM zlecenia '+
                             'WHERE status = ''wystawione'' '+
//                             'AND ID_ZLEC_TECHNOLOGIE = 53 ' +
                             'ORDER BY rok ' + sortowanie + ', miesiac ' + sortowanie);

    while not Query1.Query.Eof do
    begin
      zlecenie := TZlecenie.Create(True);
      zlecenie.daneZlecenia.UstawDlaQueryZeZlecenia(Query1.Query);
      zlecenia.Add(zlecenie);
      poprzedniEtapZlecenia := nil;
      ID_ZLEC_TECHNOLOGIE := Query1.Query.FieldByName('ID_ZLEC_TECHNOLOGIE').AsInteger;
      Query2.fetchQuery('SELECT * '+
                                    'FROM zlec_technologie_etapy '+
                                    'WHERE id_zlec_technologie = '+ IntToStr(ID_ZLEC_TECHNOLOGIE) + ' ' +
                                    'ORDER BY nr_etapu ' + sortowanie);

      while not Query2.Query.Eof do
      begin
        etapZlecenia := TZlecenieEtap.Create;
        etapZlecenia.UstawDlaQueryZeZlecTechnologieEtapy(Query2.Query);

//        if not (poprzedniEtapZlecenia = nil) then
//        begin
//          etapZlecenia.poprzedniEtap := poprzedniEtapZlecenia;
//          poprzedniEtapZlecenia.nastepnyEtap := etapZlecenia;
//        end;

        zlecenie.Add(etapZlecenia, wprzod);
        poprzedniEtapZlecenia := etapZlecenia;
        Query2.Query.Next;
      end;

      Query1.Query.Next;
    end;
    Result := zlecenia;
  end;

  function TDataBaseHelper.WyciagnijStanowiskaDoHarmonogramowania : TStanowiska;
  var
    stanowiska : TStanowiska;
    stanowisko : TStanowisko;
    ID_RODZAJE_STANOWISK : Integer;
  begin
    stanowiska := TStanowiska.Create(True);
    Query1.fetchQuery('SELECT * FROM stanowiska');

    while not Query1.Query.Eof do
    begin
      stanowisko := TStanowisko.Create;
      stanowiska.Add(stanowisko);

      ID_RODZAJE_STANOWISK := Query1.Query.FieldByName('ID_RODZAJE_STANOWISK').AsInteger;
      Query2.fetchQuery('SELECT * FROM rodzaje_stanowisk '+
                        'WHERE id_rodzaje_stanowisk = '+ IntToStr(ID_RODZAJE_STANOWISK));

      stanowisko.UstawDlaQueryZeStanowiska(Query1.Query);
      stanowisko.UstawDlaQueryZRodzajeStanowisk(Query2.Query);

      Query1.Query.Next;
    end;
    Result := stanowiska;
  end;

end.
