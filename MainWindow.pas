unit MainWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB,
  Bde.DBTables, Vcl.Grids, Vcl.DBGrids, Data.Win.ADODB, VCLTee.TeEngine,
  VCLTee.Series, VCLTee.GanttCh, VCLTee.TeeGanttTool, VCLTee.TeeProcs,
  VCLTee.Chart, DataBaseHelper, Zlecenia, Zlecenie, ZlecenieEtap, Harmonogramator, CzasHelper, Stanowiska, Stanowisko, KolorHelper, System.DateUtils,
  DyspozytorskaRegulaHarmonogramowaniaSPTO, DyspozytorskaRegulaHarmonogramowaniaSPTW, DyspozytorskaRegulaHarmonogramowaniaEDDW, DyspozytorskaRegulaHarmonogramowaniaMDD, DyspozytorskaRegulaHarmonogramowaniaMST,
  DyspozytorskaRegulaHarmonogramowaniaSCRW, DyspozytorskaRegulaHarmonogramowaniaAOPN, DyspozytorskaRegulaHarmonogramowaniaSOPN, DyspozytorskaRegulaHarmonogramowania1ST,
  DyspozytorskaRegulaHarmonogramowania, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    UstawieniaHarmonogramu: TGroupBox;
    ADOConnection1: TADOConnection;
    Button2: TButton;
    Memo1: TMemo;
    WykresGantta: TChart;
    ChartTool1: TGanttTool;
    SeriaDanychGantta: TGanttSeries;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    TabZlecen: TTabControl;
    PanelKoloruZlecenia: TPanel;
    TabelaHarmonogramu: TStringGrid;
    SaveToDBButton: TButton;
    LoadFromDBButton: TButton;
    ListaStanowiskDoWyboru: TListBox;
    DatePicker: TDateTimePicker;
    PanelWyboruDatyCzasu: TPanel;
    TimePicker: TDateTimePicker;
    PrzyciskZatwierdzDateCzas: TButton;
    procedure Button2Click(Sender: TObject);
    procedure ChartTool1DragBar(Sender: TGanttTool; GanttBar: Integer);
    procedure WykresGanttaMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SeriaDanychGanttaClick(Sender: TChartSeries; ValueIndex: Integer;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TabZlecenChange(Sender: TObject);
    procedure AutoSizeCol(Grid: TStringGrid; Column: integer);
    procedure PrzydzielEtapyDoStanowisk;
    procedure NaniesEtapyZeStanowiskNaWykres;
    procedure ZbudujKoloryITaby;
    function ZaznaczonyEtapWTabeli : TZlecenieEtap;
    procedure WyswietlPanelWyboruStanowisk;
    procedure WyswietlPanelWyboruDatyCzasu(tag : Integer);
    procedure WyswietlKomponentPoKliknieciuNaTabele(komponent : TControl);
    procedure SaveToDBButtonClick(Sender: TObject);
    procedure LoadFromDBButtonClick(Sender: TObject);
    procedure StringGrid1OnDblClick(Sender: TObject);
    procedure ListaStanowiskDoWyboruExit(Sender: TObject);
    procedure ListaStanowiskDoWyboruDblClick(Sender: TObject);
    procedure PanelWyborDatyCzasuExit(Sender: TObject);
    procedure PrzyciskZatwierdzDateCzasClick(Sender: TObject);
  private

    zlecenia : TZlecenia;
    stanowiska : TStanowiska;

    procedure harmonogramuj;

    //helpery
    procedure print(printString : String);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1 : TForm1;
  DBH : TDataBaseHelper;
  CH : TCzasHelper;
  KH : TKolorHelper;
  Harmonogramator : THarmonogramator;
  LastDraggedBarNumber : Integer = -1;
  drhArray : array[1..9] of TDyspozytorskaRegulaHarmonogramowania;
  TAG_WYBOR_POCZATKU : Integer = 0;
  TAG_WYBOR_KONCA : Integer = 1;

implementation

{$R *.dfm}

procedure TForm1.harmonogramuj;
var
  zlecenie : TZlecenie;
  etapZlecenia : TZlecenieEtap;
  stanowisko : TStanowisko;
  drh : TDyspozytorskaRegulaHarmonogramowania;
begin
  if not (ComboBox1.ItemIndex = -1) then
  begin
    drh := ComboBox1.Items.Objects[ComboBox1.ItemIndex] as TDyspozytorskaRegulaHarmonogramowania;

    SeriaDanychGantta.Clear;

    zlecenia.Czysc;
    stanowiska.Czysc;

    Harmonogramator.Harmonogramuj(zlecenia, stanowiska, drh);
    print('Harmonogram dla reguly: ' + drh.NazwaReguly);
  end;

  NaniesEtapyZeStanowiskNaWykres;
  TabZlecenChange(TabZlecen);
end;

procedure TForm1.SaveToDBButtonClick(Sender: TObject);
var
  zlecenie : TZlecenie;
  etap : TZlecenieEtap;
begin
  for zlecenie in zlecenia do
    for etap in zlecenie do
      DBH.ZapiszEtap(etap);
end;

procedure TForm1.StringGrid1OnDblClick(Sender: TObject);
var
  nazwaKolumny : string;
begin
  if not (TabelaHarmonogramu.Row = 0) then
  begin
    nazwaKolumny := TabelaHarmonogramu.Cols[TabelaHarmonogramu.Col].Strings[0];
    if (nazwaKolumny = 'id_stanowiska_przydzielenie') then
      WyswietlPanelWyboruStanowisk
    else if (nazwaKolumny = 'data_rozpoczecia') then
      WyswietlPanelWyboruDatyCzasu(TAG_WYBOR_POCZATKU)
    else if (nazwaKolumny = 'data_zakonczenia') then
      WyswietlPanelWyboruDatyCzasu(TAG_WYBOR_KONCA);
  end;
end;

procedure TForm1.WyswietlPanelWyboruStanowisk;
var
  etapZlecenia : TZlecenieEtap;
  stanowiskaPasujace : TStanowiska;
  stanowisko : TStanowisko;
begin
  ListaStanowiskDoWyboru.Items.Clear;
    etapZlecenia := ZaznaczonyEtapWTabeli;
    stanowiskaPasujace := stanowiska.StanowiskaPasujaceDlaEtapuZlecenia(etapZlecenia);
    for stanowisko in stanowiskaPasujace do
    begin
      ListaStanowiskDoWyboru.Items.Add(stanowisko.NAZ_STANOWISKA);
    end;
    WyswietlKomponentPoKliknieciuNaTabele(ListaStanowiskDoWyboru);
    ListaStanowiskDoWyboru.SetFocus;
end;

procedure TForm1.WyswietlKomponentPoKliknieciuNaTabele(komponent : TControl);
var
  rect : TRect;
begin
  rect := TabelaHarmonogramu.CellRect(TabelaHarmonogramu.Col, TabelaHarmonogramu.Row);
  komponent.Left := rect.Left + TabelaHarmonogramu.Left;
  komponent.Top := rect.Bottom + TabelaHarmonogramu.Top;
  if komponent.Width < rect.Right - rect.Left then
    komponent.Width := rect.Right - rect.Left;
  if (TabelaHarmonogramu.Top + TabelaHarmonogramu.Height < komponent.Top + komponent.Height) then
    komponent.Top := (TabelaHarmonogramu.Top + TabelaHarmonogramu.Height) - komponent.Height;

  komponent.Visible := True;
end;

function TForm1.ZaznaczonyEtapWTabeli : TZlecenieEtap;
var
  zlecenie : TZlecenie;
begin
  Result := nil;
  zlecenie := zlecenia.Items[TabZlecen.TabIndex];
  if TabelaHarmonogramu.Row - 1 < zlecenie.Count then
    Result := zlecenie.Items[TabelaHarmonogramu.Row - 1];
end;

procedure TForm1.WyswietlPanelWyboruDatyCzasu(tag: Integer);
var
  etapZlecenia : TZlecenieEtap;
  dataDoUstawienia : TDateTime;
begin
  etapZlecenia := ZaznaczonyEtapWTabeli;
  if tag = TAG_WYBOR_POCZATKU then dataDoUstawienia := etapZlecenia.DATA_ROZPOCZECIA
  else dataDoUstawienia := etapZlecenia.DATA_ZAKONCZENIA;

  DatePicker.DateTime := DateOf(dataDoUstawienia);
  TimePicker.DateTime := TimeOf(dataDoUstawienia);
  PanelWyboruDatyCzasu.Tag := tag;

  WyswietlKomponentPoKliknieciuNaTabele(PanelWyboruDatyCzasu);
  DatePicker.SetFocus;
end;

procedure TForm1.SeriaDanychGanttaClick(Sender: TChartSeries; ValueIndex: Integer;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  kliknietyEtapZlecenia, pierwszyEtap, ostatniEtap : TZlecenieEtap;
begin
  Memo1.Text := 'clicked ' + IntToStr(ValueIndex) + #13#10;
  kliknietyEtapZlecenia := zlecenia.ZnajdzEtapZleceniaZGanttId(ValueIndex);
  if not (kliknietyEtapZlecenia = nil) then
  begin
    print('======= ZLECENIE =======');
    print('ID_ZLECENIA ' + IntToStr(kliknietyEtapZlecenia.daneZlecenia.ID_ZLECENIA));
    print('Rozpoczecie ' + DateTimeToStr(kliknietyEtapZlecenia.daneZlecenia.PLAN_DATA_ROZPOCZECIA));
    print('Zakonczenie ' + DateTimeToStr(kliknietyEtapZlecenia.daneZlecenia.PLAN_TERMIN_REALIZACJI));
    print('==== ETAP ZLECENIA =====');
    print('NR_ETAPU ' + IntToStr(kliknietyEtapZlecenia.NR_ETAPU));
    print('Rozpoczecie ' + DateTimeToStr(kliknietyEtapZlecenia.DATA_ROZPOCZECIA));
    print('Zakonczenie ' + DateTimeToStr(kliknietyEtapZlecenia.DATA_ZAKONCZENIA));
    print('==== PIERWSZY ETAP =====');
    pierwszyEtap := kliknietyEtapZlecenia.PierwszyEtap;
    print('NR_ETAPU ' + IntToStr(pierwszyEtap.NR_ETAPU));
    print('Rozpoczecie ' + DateTimeToStr(pierwszyEtap.DATA_ROZPOCZECIA));
    print('Zakonczenie ' + DateTimeToStr(pierwszyEtap.DATA_ZAKONCZENIA));
    print('===== OSTATNI ETAP =====');
    ostatniEtap := kliknietyEtapZlecenia.OstatniEtap;
    print('NR_ETAPU ' + IntToStr(ostatniEtap.NR_ETAPU));
    print('Rozpoczecie ' + DateTimeToStr(ostatniEtap.DATA_ROZPOCZECIA));
    print('Zakonczenie ' + DateTimeToStr(ostatniEtap.DATA_ZAKONCZENIA));
  end;
end;

procedure TForm1.TabZlecenChange(Sender: TObject);
var
  zlecenie : TZlecenie;
  sl : TStringList;
  etap : TZlecenieEtap;
  i : Integer;
begin
  PanelWyboruDatyCzasu.Visible := False;
  ListaStanowiskDoWyboru.Visible := False;
  zlecenie := zlecenia.Items[TabZlecen.TabIndex];
  PanelKoloruZlecenia.Color := KH.KolorDlaId(zlecenie.daneZlecenia.ID_ZLECENIA);
  TabelaHarmonogramu.RowCount := 1;
  sl := TStringList.Create;
  for etap in zlecenie do
  begin
    sl.Clear;

    sl.Add(IntToStr(etap.NR_ETAPU));
    sl.Add(IntToStr(etap.ID_RODZAJE_STANOWISK));
    if not (etap.ID_STANOWISKA = 0) then
      sl.Add(IntToStr(etap.ID_STANOWISKA))
    else
      sl.Add(' ');
    if not (etap.DATA_ROZPOCZECIA = 0) then
      sl.Add(DateTimeToStr(etap.DATA_ROZPOCZECIA))
    else
      sl.Add(' ');
    if not (etap.DATA_ZAKONCZENIA = 0) then
      sl.Add(DateTimeToStr(etap.DATA_ZAKONCZENIA))
    else
      sl.Add(' ');
    if not (etap.ID_STANOWISKA_PRZYDZIELENIE = 0) then
      sl.Add(stanowiska.StanowiskoZId(etap.ID_STANOWISKA_PRZYDZIELENIE).NAZ_STANOWISKA)
    else
      sl.Add(' ');

    i := TabelaHarmonogramu.RowCount;
    TabelaHarmonogramu.RowCount := i + 1;
    TabelaHarmonogramu.Rows[i].Clear;
    TabelaHarmonogramu.Rows[i].AddStrings(sl);
  end;
  sl.Free;
  for i := 0 to TabelaHarmonogramu.ColCount - 1 do
    AutoSizeCol(TabelaHarmonogramu, i);
end;

procedure TForm1.print(printString : String);
begin
  Memo1.Text := Memo1.Text + printString + #13#10;
end;

procedure TForm1.ListaStanowiskDoWyboruDblClick(Sender: TObject);
var
  etapZlecenia : TZlecenieEtap;
  poprzednieStanowisko : TStanowisko;
  nastepneStanowisko : TStanowisko;
begin
  etapZlecenia := ZaznaczonyEtapWTabeli;
  poprzednieStanowisko := stanowiska.StanowiskoZId(etapZlecenia.ID_STANOWISKA_PRZYDZIELENIE);
  nastepneStanowisko := stanowiska
    .StanowiskaPasujaceDlaEtapuZlecenia(etapZlecenia)
    .Items[ListaStanowiskDoWyboru.ItemIndex];
  if not (poprzednieStanowisko = nastepneStanowisko) then
  begin
    poprzednieStanowisko.UsunEtap(etapZlecenia);
    nastepneStanowisko.DodajEtap(etapZlecenia);
    etapZlecenia.ID_STANOWISKA_PRZYDZIELENIE := nastepneStanowisko.ID_STANOWISKA;
    NaniesEtapyZeStanowiskNaWykres;
    TabZlecenChange(TabZlecen);
  end;
  ListaStanowiskDoWyboru.Visible := false;
end;

procedure TForm1.ListaStanowiskDoWyboruExit(Sender: TObject);
begin
  ListaStanowiskDoWyboru.Visible := False;
end;

procedure TForm1.PanelWyborDatyCzasuExit(Sender: TObject);
begin
  PanelWyboruDatyCzasu.Visible := False;
end;

procedure TForm1.LoadFromDBButtonClick(Sender: TObject);
begin
  zlecenia.Free;
  zlecenia := DBH.WyciagnijZleceniaDoHarmonogramowania;
  stanowiska.Czysc;

  PrzydzielEtapyDoStanowisk;
  NaniesEtapyZeStanowiskNaWykres;
  self.TabZlecenChange(TabZlecen);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  harmonogramuj;
end;

procedure TForm1.WykresGanttaMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if LastDraggedBarNumber >= 0 then
  begin
    Memo1.Text := 'Last Dragged Bar #' + IntToStr(LastDraggedBarNumber);
    LastDraggedBarNumber := -1;
  end;
end;

procedure TForm1.ChartTool1DragBar(Sender: TGanttTool; GanttBar: Integer);
begin
  LastDraggedBarNumber := GanttBar;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  ChartTool1.AllowDrag := CheckBox1.Checked;
  WykresGantta.Zoom.Allow := not(CheckBox1.Checked);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  I: Integer;
  zlecenie: TZlecenie;
begin
  DBH := TDataBaseHelper.Create(ADOConnection1);
  CH := TCzasHelper.Create(EncodeTime(8,0,0,0),EncodeTime(16,0,0,0));
  KH := TKolorHelper.Create;
  Harmonogramator := THarmonogramator.Create(CH);
  drhArray[1] := TDyspozytorskaRegulaHarmonogramowaniaSPTO.Create(CH);
  drhArray[2] := TDyspozytorskaRegulaHarmonogramowaniaSPTW.Create(CH);
  drhArray[3] := TDyspozytorskaRegulaHarmonogramowaniaEDDW.Create(CH);
  drhArray[4] := TDyspozytorskaRegulaHarmonogramowaniaMDD.Create(CH);
  drhArray[5] := TDyspozytorskaRegulaHarmonogramowaniaMST.Create(CH);
  drhArray[6] := TDyspozytorskaRegulaHarmonogramowaniaSCRW.Create(CH);
  drhArray[7] := TDyspozytorskaRegulaHarmonogramowaniaAOPN.Create(CH);
  drhArray[8] := TDyspozytorskaRegulaHarmonogramowaniaSOPN.Create(CH);
  drhArray[9] := TDyspozytorskaRegulaHarmonogramowania1ST.Create(CH);
  for I := 1 to Length(drhArray) do
  begin
    ComboBox1.AddItem(drhArray[I].NazwaReguly, drhArray[I]);
  end;
  ComboBox1.ItemIndex := 0;

  TabelaHarmonogramu.Cols[0].Add('nr_etapu');
  TabelaHarmonogramu.Cols[1].Add('id_rodzaje_stanowisk');
  TabelaHarmonogramu.Cols[2].Add('id_stanowiska');
  TabelaHarmonogramu.Cols[3].Add('data_rozpoczecia');
  TabelaHarmonogramu.Cols[4].Add('data_zakonczenia');
  TabelaHarmonogramu.Cols[5].Add('id_stanowiska_przydzielenie');

  zlecenia := DBH.WyciagnijZleceniaDoHarmonogramowania;
  stanowiska := DBH.WyciagnijStanowiskaDoHarmonogramowania;

  ZbudujKoloryITaby;

  PrzydzielEtapyDoStanowisk;
  NaniesEtapyZeStanowiskNaWykres;
  TabZlecenChange(TabZlecen);
  // TODO: add machine
end;

procedure TForm1.FormDestroy(Sender: TObject);
//var
//  I: Integer;
begin
//  for I := 1 to Length(drhArray) do
//    drhArray[1].Free;
//  if not (DBH = nil) then DBH.Free;
//  if not (CH = nil) then CH.Free;
//  if not (zlecenia = nil) then zlecenia.Free;
//  if not (stanowiska = nil) then stanowiska.Free;
//  if not (Harmonogramator = nil) then Harmonogramator.Free;

//  DBH.Free;
end;

procedure TForm1.AutoSizeCol(Grid: TStringGrid; Column: integer);
var
  i, W, WMax: integer;
begin
  WMax := 0;
  for i := 0 to (Grid.RowCount - 1) do begin
    W := Grid.Canvas.TextWidth(Grid.Cells[Column, i]);
    if W > WMax then
      WMax := W;
  end;
  Grid.ColWidths[Column] := WMax + 10;
end;

procedure TForm1.PrzyciskZatwierdzDateCzasClick(Sender: TObject);
var
  etapZlecenia : TZlecenieEtap;
  dataCzasDoZapisania : TDateTime;
begin
  etapZlecenia := ZaznaczonyEtapWTabeli;
  dataCzasDoZapisania := DatePicker.DateTime + TimePicker.DateTime;
  if PanelWyboruDatyCzasu.Tag = TAG_WYBOR_POCZATKU then
    etapZlecenia.DATA_ROZPOCZECIA := dataCzasDoZapisania
  else if PanelWyboruDatyCzasu.Tag = TAG_WYBOR_KONCA then
    etapZlecenia.DATA_ZAKONCZENIA := dataCzasDoZapisania;
  PanelWyboruDatyCzasu.Visible := False;

  PrzydzielEtapyDoStanowisk;
  NaniesEtapyZeStanowiskNaWykres;
  TabZlecenChange(TabZlecen);
end;

procedure TForm1.PrzydzielEtapyDoStanowisk;
var
  etap : TZlecenieEtap;
  zlecenie : TZlecenie;
begin
  for zlecenie in zlecenia do
    for etap in zlecenie do
      if (
        ( not (etap.ID_STANOWISKA_PRZYDZIELENIE = 0)) and
        ( not (etap.DATA_ROZPOCZECIA = 0)) and
        ( not (etap.DATA_ZAKONCZENIA = 0))
      ) then
        stanowiska.StanowiskoZId(etap.ID_STANOWISKA_PRZYDZIELENIE).DodajEtap(etap);
end;

procedure TForm1.NaniesEtapyZeStanowiskNaWykres;
var
  stanowisko : TStanowisko;
  etapZlecenia : TZlecenieEtap;
begin
  SeriaDanychGantta.Clear;
  for stanowisko in stanowiska do
  begin
    for etapZlecenia in stanowisko.listaEtapow do
    begin
      if (
        not (etapZlecenia.DATA_ROZPOCZECIA = 0) and
        not (etapZlecenia.DATA_ZAKONCZENIA = 0) and
        not (etapZlecenia.ID_STANOWISKA_PRZYDZIELENIE = 0)) then
        begin
          etapZlecenia.ganttID := SeriaDanychGantta.AddGanttColor(etapZlecenia.DATA_ROZPOCZECIA,
                                                    etapZlecenia.DATA_ZAKONCZENIA,
                                                    stanowiska.IndexOf(stanowisko),
                                                    stanowisko.NAZ_STANOWISKA,
                                                    KH.KolorDlaId(etapZlecenia.daneZlecenia.ID_ZLECENIA));
        end;
    end;
  end;
  zlecenia.PolaczKolejneEtapyZlecenWSerii(SeriaDanychGantta);
end;

procedure TForm1.ZbudujKoloryITaby;
var
  zlecenie : TZlecenie;
  i, id_zlecenia : Integer;
begin
  i := TabZlecen.TabIndex;
  TabZlecen.Tabs.Clear;
  for zlecenie in zlecenia do
  begin
    KH.KolorDlaId(zlecenie.daneZlecenia.ID_ZLECENIA);
    TabZlecen.Tabs.Add(IntToStr(zlecenie.daneZlecenia.ID_ZLECENIA));
  end;
//  if not (i = -1) and (i < TabZlecen.Tabs.Count) then

end;

end.
