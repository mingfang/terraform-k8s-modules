package library.kubernetes.admission.mutating

############################################################
# PATCH rules
#
# Note: All patch rules should start with `isValidRequest` and `isCreateOrUpdate`
############################################################

patch[patchCode] {
	isValidRequest
	isCreateOrUpdate
	input.request.kind.kind == "Namespace"
    startswith(input.request.name, "legionx-")
	not hasAnnotation(input.request.object, "scheduler.alpha.kubernetes.io/node-selector")
    patchCode = makeAnnotationPatch("add", "scheduler.alpha.kubernetes.io/node-selector", "host=ripper2", "")
}