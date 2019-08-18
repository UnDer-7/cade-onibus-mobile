class UtilException implements Exception {
    final String msg;
    final String classOrigin;
    final String methodOrigin;
    final String lineOrigin;

    UtilException(
        this.msg,
    {
     this.classOrigin,
     this.methodOrigin,
     this.lineOrigin,
    });
}
