SELECT TableName, DataPages, AvgFragmentationBeforeDefrag, DefragType, DefragStart, DefragEnd, DATEDIFF (minute, DefragStart, DefragEnd)--, *
FROM maint.Index_Space_Used IT
WHERE DefragStart > '08/14/2019'
AND DATEDIFF (minute, DefragStart, DefragEnd) > 10
--AND DefragType = 'REBUILD'
--AND AvgFragmentationBeforeDefrag > 20.0
ORDER BY IT.TableName, IT.DataPages DESC, IT.AvgFragmentationBeforeDefrag DESC