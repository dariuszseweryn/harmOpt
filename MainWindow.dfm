object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 951
  ClientWidth = 898
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 892
    Height = 54
    Align = alTop
    Caption = 'Ustawienia Harmonogramowania'
    TabOrder = 0
    object Button2: TButton
      Left = 16
      Top = 19
      Width = 171
      Height = 25
      Caption = 'Harmonogramuj'
      TabOrder = 0
      OnClick = Button2Click
    end
    object CheckBox1: TCheckBox
      Left = 440
      Top = 23
      Width = 273
      Height = 17
      Caption = 'Pozw'#243'l na przeci'#261'ganie etap'#243'w'
      TabOrder = 1
      OnClick = CheckBox1Click
    end
    object ComboBox1: TComboBox
      Left = 208
      Top = 21
      Width = 209
      Height = 21
      TabOrder = 2
      Text = 'ComboBox1'
    end
    object SaveToDBButton: TButton
      Left = 792
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Zapisz'
      TabOrder = 3
      OnClick = SaveToDBButtonClick
    end
    object LoadFromDBButton: TButton
      Left = 664
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Wczytaj'
      TabOrder = 4
      OnClick = LoadFromDBButtonClick
    end
  end
  object Memo1: TMemo
    AlignWithMargins = True
    Left = 3
    Top = 836
    Width = 892
    Height = 125
    Align = alTop
    BiDiMode = bdLeftToRight
    Lines.Strings = (
      'Memo1')
    ParentBiDiMode = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Chart1: TChart
    AlignWithMargins = True
    Left = 3
    Top = 63
    Width = 892
    Height = 442
    BackWall.Brush.Gradient.Direction = gdBottomTop
    BackWall.Brush.Gradient.EndColor = clWhite
    BackWall.Brush.Gradient.StartColor = 15395562
    BackWall.Brush.Gradient.Visible = True
    BackWall.Transparent = False
    Foot.Font.Name = 'Verdana'
    Gradient.Direction = gdBottomTop
    Gradient.EndColor = clWhite
    Gradient.MidColor = 15395562
    Gradient.StartColor = 15395562
    Gradient.Visible = True
    LeftWall.Color = 14745599
    Legend.Font.Name = 'Verdana'
    Legend.Visible = False
    RightWall.Color = 14745599
    SubFoot.Font.Name = 'Verdana'
    SubTitle.Font.Name = 'Verdana'
    Title.Font.Name = 'Verdana'
    Title.Text.Strings = (
      'TChart')
    AxisBehind = False
    BottomAxis.Axis.Color = 4210752
    BottomAxis.Grid.Color = 11119017
    BottomAxis.LabelsFont.Name = 'Verdana'
    BottomAxis.TicksInner.Color = 11119017
    BottomAxis.Title.Font.Name = 'Verdana'
    DepthAxis.Axis.Color = 4210752
    DepthAxis.Grid.Color = 11119017
    DepthAxis.LabelsFont.Name = 'Verdana'
    DepthAxis.TicksInner.Color = 11119017
    DepthAxis.Title.Font.Name = 'Verdana'
    DepthTopAxis.Axis.Color = 4210752
    DepthTopAxis.Grid.Color = 11119017
    DepthTopAxis.LabelsFont.Name = 'Verdana'
    DepthTopAxis.TicksInner.Color = 11119017
    DepthTopAxis.Title.Font.Name = 'Verdana'
    LeftAxis.Axis.Color = 4210752
    LeftAxis.Grid.Color = 11119017
    LeftAxis.LabelsFont.Name = 'Verdana'
    LeftAxis.TicksInner.Color = 11119017
    LeftAxis.Title.Font.Name = 'Verdana'
    RightAxis.Axis.Color = 4210752
    RightAxis.Grid.Color = 11119017
    RightAxis.LabelsFont.Name = 'Verdana'
    RightAxis.TicksInner.Color = 11119017
    RightAxis.Title.Font.Name = 'Verdana'
    TopAxis.Axis.Color = 4210752
    TopAxis.Grid.Color = 11119017
    TopAxis.LabelsFont.Name = 'Verdana'
    TopAxis.TicksInner.Color = 11119017
    TopAxis.Title.Font.Name = 'Verdana'
    Align = alTop
    TabOrder = 2
    Anchors = [akLeft, akTop, akRight, akBottom]
    OnMouseUp = Chart1MouseUp
    PrintMargins = (
      15
      33
      15
      33)
    ColorPaletteIndex = 13
    object Series1: TGanttSeries
      Marks.Arrow.Visible = True
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = True
      Marks.ShapeStyle = fosRoundRectangle
      Marks.Visible = False
      OnClick = Series1Click
      ClickableLine = False
      Pointer.Brush.Gradient.EndColor = 11048782
      Pointer.Gradient.EndColor = 11048782
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.VertSize = 15
      Pointer.Visible = True
      XValues.Name = 'Start'
      XValues.Order = loNone
      YValues.Name = 'Y'
      YValues.Order = loNone
      StartValues.Name = 'Start'
      StartValues.Order = loNone
      EndValues.Name = 'End'
      EndValues.Order = loNone
      NextTask.Name = 'NextTask'
      NextTask.Order = loNone
    end
    object ChartTool1: TGanttTool
      AllowDrag = False
      AllowResize = False
      Series = Series1
      OnDragBar = ChartTool1DragBar
    end
  end
  object TabControl1: TTabControl
    Left = 0
    Top = 508
    Width = 898
    Height = 325
    Align = alTop
    TabOrder = 3
    OnChange = TabControl1Change
    object Panel1: TPanel
      Left = 4
      Top = 27
      Width = 890
      Height = 29
      Align = alBottom
      Caption = 'Kolor zlecenia'
      ParentBackground = False
      TabOrder = 0
    end
    object StringGrid1: TStringGrid
      Left = 4
      Top = 56
      Width = 890
      Height = 265
      Align = alBottom
      ColCount = 6
      RowCount = 1
      FixedRows = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
      TabOrder = 1
      OnDblClick = StringGrid1OnDblClick
    end
    object ListBox1: TListBox
      Left = 48
      Top = 120
      Width = 121
      Height = 97
      ItemHeight = 13
      TabOrder = 2
      Visible = False
      OnDblClick = ListBox1DblClick
      OnExit = ListBox1Exit
    end
  end
  object ADOConnection1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=SQLOLEDB.1;Persist Security Info=False;User ID=sa;Passw' +
      'ord=sa123;Initial Catalog=PRODUSYS_RR;Data Source=PRODUSOFT\SQLE' +
      'XPRESS;'
    LoginPrompt = False
    Mode = cmRead
    Provider = 'SQLOLEDB.1'
    Left = 672
    Top = 24
  end
end
