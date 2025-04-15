Select aaa.AssetID,
  aaa.icon,
  aaa.AssetName,
  aaa.[If],
  aaa.Type,
  aaa.Admin,
  aaa.MTU,
  aaa.Speed,
  aaa.[IP Address],
  aaa.Mask,
  aaa.Portname,
  aaa.Vlan,
  aaa.MacAddress,
  tsysAssetTypes_1.AssetTypeIcon16 As icon2,
  aaa.deviceassetid,
  tblAssets.AssetName As deviceassetname,
  aaa.AssetMacAddress,
  tblAssets.Description,
  tblAssetCustom.Manufacturer,
  tblAssetCustom.Model,
  tblAssetCustom.Location,
  tsysIPLocations.IPLocation,
  tblAssets.Firstseen As [Created at],
  tblAssets.Lastseen As [Last successful scan]
From (Select Top (1000000) tblAssets_1.AssetID,
      tsysAssetTypes.AssetTypeIcon10 As icon,
      tblAssets_1.AssetName,
      tblSNMPInfo.IfIndex As [If],
      tblSNMPIfTypes.IfTypename As Type,
      Case
        When tblSNMPInfo.IfAdminstatus = 1 Then 'Up'
        When tblSNMPInfo.IfAdminstatus = 2 Then 'Down'
        Else 'Testing'
      End As Admin,
      tblSNMPInfo.IfMTU As MTU,
      Case
        When (tblSNMPInfo.IfSpeed Is Null Or tblSNMPInfo.IfSpeed = 0) Then ''
        When tblSNMPInfo.IfSpeed > 999999999 Then
          Convert(nvarchar(255),Cast(tblSNMPInfo.IfSpeed / 1000000000 As float))
          + 'Gbit'
        When tblSNMPInfo.IfSpeed > 999999 Then
          Convert(nvarchar(255),Cast(tblSNMPInfo.IfSpeed / 1000000 As float)) +
          'Mbit'
        Else Convert(nvarchar(255),Cast(tblSNMPInfo.IfSpeed / 1000 As float)) +
          'Kbit'
      End As Speed,
      tblSNMPInfo.IfIPAddress As [IP Address],
      tblSNMPInfo.IfMask As Mask,
      tblSNMPInfo.IfMacaddress As MacAddress,
      tblSNMPAssetMac.AssetMacAddress,
      tblSNMPInfo.Portname,
      tblSNMPInfo.Vlan,
      tblAssetMacAddress.AssetID As deviceassetid
    From tblSNMPInfo
      Inner Join tblAssets As tblAssets_1 On tblSNMPInfo.AssetID =
          tblAssets_1.AssetID
      Inner Join tsysAssetTypes On tblAssets_1.Assettype =
          tsysAssetTypes.AssetType
      Left Outer Join tblSNMPIfTypes On tblSNMPInfo.IfType =
          tblSNMPIfTypes.IfType
      Left Outer Join (tblAssetMacAddress
      Right Outer Join tblSNMPAssetMac On tblAssetMacAddress.Mac =
          tblSNMPAssetMac.AssetMacAddress) On tblSNMPInfo.IfIndex =
          tblSNMPAssetMac.IfIndex And tblSNMPInfo.AssetID =
          tblSNMPAssetMac.AssetID
    Where tblAssets_1.AssetID Is Not Null And tblAssets_1.Assettype = 6
    Order By tblAssets_1.AssetName,
      [If]) As aaa
  Left Outer Join tblAssets On aaa.deviceassetid = tblAssets.AssetID
  Left Outer Join tsysAssetTypes As tsysAssetTypes_1 On tblAssets.Assettype =
      tsysAssetTypes_1.AssetType
  Inner Join tblAssetCustom On tblAssetCustom.AssetID = tblAssets.AssetID
  Left Outer Join tsysIPLocations On tblAssets.LocationID =
      tsysIPLocations.LocationID

