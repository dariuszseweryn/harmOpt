object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 799
  ClientWidth = 919
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 913
    Height = 97
    Align = alTop
    Caption = 'Connection Configuration'
    TabOrder = 0
    object Button1: TButton
      Left = 16
      Top = 23
      Width = 75
      Height = 25
      Caption = 'Chart'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 112
      Top = 23
      Width = 75
      Height = 25
      Caption = 'Harm'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 776
      Top = 23
      Width = 75
      Height = 25
      Caption = 'Button3'
      TabOrder = 2
      OnClick = Button3Click
    end
    object CheckBox1: TCheckBox
      Left = 16
      Top = 64
      Width = 171
      Height = 17
      Caption = 'Przeci'#261'ganie'
      TabOrder = 3
      OnClick = CheckBox1Click
    end
  end
  object Memo1: TMemo
    AlignWithMargins = True
    Left = 3
    Top = 106
    Width = 913
    Height = 367
    Align = alTop
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object Chart1: TChart
    AlignWithMargins = True
    Left = 3
    Top = 479
    Width = 913
    Height = 302
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
    RightWall.Color = 14745599
    SubFoot.Font.Name = 'Verdana'
    SubTitle.Font.Name = 'Verdana'
    Title.Font.Name = 'Verdana'
    Title.Text.Strings = (
      'TChart')
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
    OnMouseUp = Chart1MouseUp
    ExplicitLeft = 8
    ExplicitTop = 489
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
      Pointer.Brush.Gradient.EndColor = 11842740
      Pointer.Gradient.EndColor = 11842740
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.VertSize = 15
      Pointer.Visible = True
      XValues.Name = 'Start'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
      StartValues.Name = 'Start'
      StartValues.Order = loAscending
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
  object ADOConnection1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=SQLOLEDB.1;Persist Security Info=False;User ID=sa;Passw' +
      'ord=sa123;Initial Catalog=PRODUSYS_RR;Data Source=PRODUSOFT\SQLE' +
      'XPRESS;'
    LoginPrompt = False
    Mode = cmRead
    Provider = 'SQLOLEDB.1'
    Left = 24
    Top = 168
  end
  object ADODataSet1: TADODataSet
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    CommandText = 'SELECT * FROM ZLEC_TECHNOLOGIE'
    Parameters = <>
    Left = 104
    Top = 152
  end
  object DataSource1: TDataSource
    DataSet = ADODataSet1
    Left = 176
    Top = 160
  end
  object ADODataSet2: TADODataSet
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    CommandText = 'SELECT * FROM ZLEC_TECHNOLOGIE'
    Parameters = <>
    Left = 368
    Top = 144
  end
  object DataSource2: TDataSource
    DataSet = ADODataSet2
    Left = 448
    Top = 160
  end
  object ADOQuery1: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 520
    Top = 160
  end
end
