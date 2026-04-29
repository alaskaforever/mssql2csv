Select tblAssets.AssetID,
  tblAssets.AssetName,
  tblAssets.Domain,
  tblAssets.Username,
  tblAssets.Userdomain,
  Coalesce(tsysOS.Image, tsysAssetTypes.AssetTypeIcon10) As icon,
  tblAssets.IPAddress,
  tsysIPLocations.IPLocation,
  tblAssetCustom.Manufacturer,
  tblAssetCustom.Model,
  tsysOS.OSname As OS,
  tblAssets.SP,
  tblAssets.Lastseen As [Last successful scan],
  tblAssets.Lasttried As [Last scan attempt],
  indirect.lastIndirectScan As [Last indirect scan],
  tblSoftwareUni.softwareName As Software,
  tblSoftware.softwareVersion As Version,
  (Select Case tblSoftware.MsStore
        When 0 Then 'Desktop app'
        Else 'Microsoft Store app'
      End) As 'Type',
  tblSoftwareUni.SoftwarePublisher As Publisher,
  tblSoftware.Lastchanged
From tblAssets
  Inner Join tblAssetCustom On tblAssets.AssetID = tblAssetCustom.AssetID
  Inner Join tsysAssetTypes On tsysAssetTypes.AssetType = tblAssets.Assettype
  Inner Join tsysIPLocations On tsysIPLocations.LocationID =
      tblAssets.LocationID
  Inner Join tblState On tblState.State = tblAssetCustom.State
  Inner Join tblSoftware On tblAssets.AssetID = tblSoftware.AssetID
  Inner Join tblSoftwareUni On tblSoftwareUni.SoftID = tblSoftware.softID
  Left Outer Join tsysOS On tsysOS.OScode = tblAssets.OScode
  Left Join (Select Max(tblIndirectScan.LastChanged) As lastIndirectScan,
      tblIndirectScan.AssetId
    From tblIndirectScan
    Group By tblIndirectScan.AssetId) indirect On tblAssetCustom.AssetId =
      indirect.AssetId
Where tblState.Statename = 'Active'
Order By tblAssets.Domain,
  tblAssets.AssetName,
  Software
