SELECT it1.typeid baseid
	,it1.typename basename
	,it2.typeid basebpid
	,it2.typename basebpname
	,it3.typeid t2id
	,it3.typename t2name
	,it4.typeid t2bpid
	,it4.typename t2bpname
	-- ,(IF (grp1.groupID IN (419,27) OR it1.typeid=17476,0.2,IF(grp1.groupID IN (26,28) OR it1.typeid=17476,0.25,IF(grp1.groupID IN (25,420,513) OR it1.typeid=17480,0.3,0.4))))*(1.05)*(1+10*(.1/5)) baseProb5
	,invent.probability*(1.05)*(1+10*(.1/5)) baseProb5
	-- ,(IF(grp1.categoryID = 6, 1, IF(grp1.groupID = 86, 40, IF(grp1.categoryID = 8, 10000, 10) ))) T2BPO_yld
	,IF(grp1.groupID = 86, 40, IF(grp1.categoryID = 8, 10000, invent.quantity)) T2_runs
	-- ,ibt1.researchCopyTime*(.75)/(IF(grp1.categoryID = 6, 1, IF(grp1.categoryID = 8, 1500, 300) )) old_copytime
	,(ibt1.researchCopyTime*(.75))/(IF(grp1.categoryID = 6,ibt1.maxProductionLimit,1)) old_copytime
	,ibt1.researchTechTime old_inventtime
	,ibt2.productionTime old_buildtime
	,ibt2.productivityModifier old_prodmod
	,cpyTime.`time` new_copytime
	,invTime.`time` new_inventtime
FROM invTypes it1
JOIN invBlueprintTypes ibt1 ON it1.typeid=ibt1.producttypeid
JOIN invTypes it2 ON it2.typeid=ibt1.blueprinttypeid
JOIN invMetaTypes imt ON imt.parenttypeid=it1.typeid
JOIN invTypes it3 ON imt.typeid=it3.typeid
JOIN invBlueprintTypes ibt2 ON it3.typeid=ibt2.producttypeid
JOIN invTypes it4 ON it4.typeid=ibt2.blueprinttypeid
JOIN invGroups grp1 ON it1.groupID = grp1.groupID
JOIN crius_bpoproducts invent ON (invent.blueprintID = it2.typeid AND invent.activityID=8)
JOIN crius_bpotimes cpyTime ON (cpyTime.blueprintID = it2.typeid AND cpyTime.activityID = 5)
JOIN crius_bpotimes invTime ON (invTime.blueprintID = it2.typeid AND invTime.activityID = 8)
JOIN crius_bpotimes bldTime ON (bldTime.blueprintID = it4.typeid AND bldTime.activityID = 1)
-- JOIN invCategories cat1 ON grp1.categoryID = cat1.categoryID
WHERE imt.metaGroupID=2
GROUP BY it3.typeid 