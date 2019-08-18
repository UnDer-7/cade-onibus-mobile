class ResourceException implements Exception {
    final String msg;
    final String classOrigin;
    final String methodOrigin;
    final String lineOrigin;

    ResourceException(
        this.msg,
    {
        this.classOrigin,
        this.methodOrigin,
        this.lineOrigin,
    });
}
