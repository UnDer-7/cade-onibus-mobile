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

    @override
    String toString() {
        StringBuffer buffer = StringBuffer();
        buffer.writeln('ResourceException: {');
        buffer.writeln('Message: $msg');
        buffer.writeln('ClassOrigin: $classOrigin');
        buffer.writeln('MethodOrigin: $methodOrigin');
        buffer.writeln('LineOrigin: $lineOrigin');
        buffer.write('}');
        return buffer.toString();
    }
}
