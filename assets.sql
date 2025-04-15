Select Top (1000000) tblAssets.AssetID,
  tblAssets.AssetName,
  tsysAssetTypes.AssetTypename,
  tsysAssetTypes.AssetTypeIcon10 As icon,
  tblAssets.IPAddress,
  tblVmwareEsxiClusters.Name As ESXICluster,
  tblVmwareDatacenters.DatacenterID,
  tblVmwareDatacenters.Name As Datacenter,
  tblAssets1.AssetName As VCenter,
  tblVmwareInfo.BiosVersion,
  tblVmwareInfo.BiosDate,
  tblVmwareInfo.BootTime,
  tblVmwareInfo.ConnectionState,
  tblVmwareInfo.CpuMhz,
  tblVmwareInfo.CpuModel,
  tblVmwareInfo.Dhcp,
  tblVmwareInfo.EsxiClusterID,
  tblVmwareInfo.HostName,
  tblVmwareInfo.InternalKey,
  tblVmwareInfo.lastchanged,
  tblVmwareInfo.ManagementServerIp,
  Cast(tblVmwareInfo.MemorySize / 1024 / 1024 / 1024 As numeric) As
  [Memory (GB)],
  tblVmwareInfo.Model,
  tblVmwareInfo.numCpuCores As CPUCores,
  tblVmwareInfo.numCpuPkgs As CPUPackages,
  tblVmwareInfo.numCpuThreads As CPUThreads,
  tblVmwareInfo.NumHbas As HBAS,
  tblVmwareInfo.NumNics As NICS,
  tblVmwareInfo.Port,
  tblVmwareInfo.PowerState,
  tblVmwareInfo.Serial,
  tblVmwareInfo.SslThumbprint,
  tblVmwareInfo.UpTime,
  tblVmwareInfo.Uuid,
  tblVmwareInfo.Vendor,
  tblVmwareInfo.Version,
  tblAssets.Lastseen As [Last successful scan],
  tblAssets.Lasttried As [Last scan attempt]
From tblAssets
  Inner Join tblAssetCustom On tblAssets.AssetID = tblAssetCustom.AssetID
  Inner Join tblState On tblState.State = tblAssetCustom.State
  Inner Join tsysAssetTypes On tsysAssetTypes.AssetType = tblAssets.Assettype
  Inner Join tblVmwareInfo On tblAssets.AssetID = tblVmwareInfo.AssetID
  Left Outer Join tblVmwareEsxiClusters On tblVmwareInfo.EsxiClusterID =
      tblVmwareEsxiClusters.EsxiClusterID
  Left Outer Join tblVmwareDatacenters On tblVmwareInfo.DatacenterID =
      tblVmwareDatacenters.DatacenterID
  Left Outer Join tblVmwareVcenters On tblVmwareVcenters.VcenterID =
      tblVmwareDatacenters.VcenterID
  Left Outer Join tblAssets As tblAssets1 On tblVmwareVcenters.AssetID =
      tblAssets1.AssetID
Where tblState.Statename = 'Active'
Order By tblAssets.IPAddress,
  tblAssets.AssetName
