class ServiceException implements Exception {
    final String msg;
    final String classOrigin;
    final String methodOrigin;
    final String lineOrigin;

    ServiceException(
        this.msg,
        {
            this.classOrigin,
            this.methodOrigin,
            this.lineOrigin,
        });
}
