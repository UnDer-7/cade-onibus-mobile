class Coordinates {
    double latitude;
    double longitude;

    Coordinates({
        this.latitude,
        this.longitude
    });

    Coordinates.fromJSON(Map<String, dynamic> json) :
            longitude = json['coordinates'][0],
            latitude = json['coordinates'][1];

    @override
    String toString() {
        StringBuffer buffer = StringBuffer();
        buffer.writeln('Coordinates: {');
        buffer.writeln('Latitude: $latitude');
        buffer.writeln('Longitude: $longitude');
        buffer.write('}');
        return buffer.toString();
    }
}
