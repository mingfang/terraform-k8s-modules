package library.kubernetes.admission.mutating

############################################################
# PATCH rules
#
# Note: All patch rules should start with `isValidRequest` and `isCreateOrUpdate`
############################################################

makeEnvPatch(op, key, value, pathPrefix) = patchCode {
	patchCode = {
		"op": op,
		"path": concat("/", [pathPrefix, "spec/containers/0", replace(key, "/", "~1")]),
		"value": value,
	}
}
patch[patchCode] {
	isValidRequest
	isCreateOrUpdate
	input.request.kind.kind == "Pod"
	patchCode = makeEnvPatch("add", "envFrom", [{"configMapRef": {"name": "podpreset"}}], "")
}