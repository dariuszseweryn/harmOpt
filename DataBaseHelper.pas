unit DataBaseHelper;

interface

uses
  System.SysUtils, Data.Win.ADODB, QueryHelper, EtapyZlecen, EtapZlecenia;

type
  TDataBaseHelper = class

  private
    procedure przygotujBazeDoZapisaniaHarmonogramowanychEtapow;
    procedure cofnijPrzygotowanieBazyDoZapisaniaHarmonogramowanychEtapow;

    function czyKolumnaIstniejeWTabeli(nazwaKolumny, nazwaTabeli : String) : Boolean;
    procedure dodajKolumneDoTabeli(nazwaKolumny, nazwaTabeli, typDanych : String);
    procedure usunKolumneZTabeli(nazwaKolumny, nazwaTabeli : String);
    { Private declarations }
  public
    { Public declarations }
    constructor HelperWithConnection(connection : TADOConnection);
    destructor Free;

    function wyciagnijEtapyZlecenDoHarmonogramowania : TEtapyZlecen;

  end;

var
  QueryZlecenia : TQueryHelper;
  QueryEtapyZlecenia : TQueryHelper;
  QueryMisc : TQueryHelper;

implementation

  constructor TDataBaseHelper.HelperWithConnection(connection : TADOConnection);
  begin
    QueryZlecenia := TQueryHelper.HelperWithConnection(connection);
    QueryEtapyZlecenia := TQueryHelper.HelperWithConnection(connection);
    QueryMisc := TQueryHelper.HelperWithConnection(connection);
  end;

  destructor TDataBaseHelper.Free;
  begin
    QueryZlecenia.Free;
    QueryEtapyZlecenia.Free;
    QueryMisc.Free;
  end;

  procedure TDataBaseHelper.przygotujBazeDoZapisaniaHarmonogramowanychEtapow;
  begin

  end;

  procedure TDataBaseHelper.cofnijPrzygotowanieBazyDoZapisaniaHarmonogramowanychEtapow;
  begin

  end;

  function TDataBaseHelper.czyKolumnaIstniejeWTabeli(nazwaKolumny, nazwaTabeli : String) : Boolean;
  begin
    QueryMisc.fetchQuery('SELECT * FROM '+ nazwaTabeli);

    if QueryMisc.Query.FieldList.Find(nazwaKolumny) = nil
    then Result := False
    else Result := True;
  end;

  procedure TDataBaseHelper.dodajKolumneDoTabeli(nazwaKolumny, nazwaTabeli, typDanych : String);
  begin
    QueryMisc.executeQuery('ALTER TABLE '+ nazwaTabeli + ' '+
                           'ADD '+ nazwaKolumny + ' ' + typDanych);
  end;

  procedure TDataBaseHelper.usunKolumneZTabeli(nazwaKolumny, nazwaTabeli : String);
  begin
    QueryMisc.executeQuery('ALTER TABLE '+ nazwaTabeli + ' '+
                           'DROP COLUMN '+ nazwaKolumny);
  end;

  function TDataBaseHelper.wyciagnijEtapyZlecenDoHarmonogramowania : TEtapyZlecen;
  var
    etapyZlecen : TEtapyZlecen;
    etapZlecenia : TEtapZlecenia;
    ID_ZLEC_TECHNOLOGIE : Integer;
  begin
    etapyZlecen := TEtapyZlecen.Create;
    QueryZlecenia.fetchQuery('SELECT * '+
                             'FROM zlecenia '+
                             'WHERE status = ''wystawione'' '+
                             'ORDER BY rok asc, miesiac asc');

    while not QueryZlecenia.Query.Eof do
    begin
      ID_ZLEC_TECHNOLOGIE := QueryZlecenia.Query.FieldByName('ID_ZLEC_TECHNOLOGIE').AsInteger;
      QueryEtapyZlecenia.fetchQuery('SELECT * '+
                                    'FROM zlec_technologie_etapy '+
                                    'WHERE id_zlec_technologie = '+ IntToStr(ID_ZLEC_TECHNOLOGIE) + ' ' +
                                    'ORDER BY nr_etapu asc');

      while not QueryEtapyZlecenia.Query.Eof do
      begin
        etapZlecenia := TEtapZlecenia.Create;
        etapZlecenia.ustawDlaQueryZeZlecenia(QueryZlecenia.Query);
        etapZlecenia.ustawDlaQueryZeZlecTechnologieEtapy(QueryEtapyZlecenia.Query);

        etapyZlecen.dodajEtap(etapZlecenia);
        QueryEtapyZlecenia.Query.Next;
      end;

      QueryZlecenia.Query.Next;
    end;
    Result := etapyZlecen;
  end;

end.
