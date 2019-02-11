object WebFloodInsights: TWebFloodInsights
  OldCreateOrder = False
  Actions = <
    item
      Default = True
      Name = 'WebActionItem1'
      PathInfo = '/General'
      OnAction = WebModule1WebActionItem1Action
    end
    item
      Name = 'WebActionItem2'
      PathInfo = '/GetFloodInfo'
      OnAction = WebModule1WebActionItem2Action
    end
    item
      Name = 'WebActionItem3'
      PathInfo = '/GetMapInfo'
      OnAction = WebModule1WebActionItem3Action
    end
    item
      Name = 'WebActionItem4'
      PathInfo = '/GetSpottedMap'
      OnAction = WebFloodInsightsWebActionItem4Action
    end>
  Left = 162
  Top = 87
  Height = 150
  Width = 215
end
