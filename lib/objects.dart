// @dart=2.9
// To parse this JSON data, do
//
//     final welcome = welcomeFromMap(jsonString);

import 'dart:convert';

Welcome welcomeFromMap(String str) => Welcome.fromMap(json.decode(str));

String welcomeToMap(Welcome data) => json.encode(data.toMap());

class Welcome {
    Welcome({
        this.result,
    });

    List<Result> result;

    factory Welcome.fromMap(Map<String, dynamic> json) => Welcome(
        result: List<Result>.from(json["result"].map((x) => Result.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "result": List<dynamic>.from(result.map((x) => x.toMap())),
    };

    List<Result> getListEvents(){
      return this.result;
    }

    int getnumeventosdestaque(){
      return result.length;
    }

}

class Result {
    Result({
        this.event,
    });

    Event event;

    factory Result.fromMap(Map<String, dynamic> json) => Result(
        event: Event.fromMap(json["event"]),
    );

    Map<String, dynamic> toMap() => {
        "event": event.toMap(),
    };
}

class Event {
    Event({
        this.id,
        this.categories,
        this.organizer,
        this.title,
        this.description,
        this.location,
        this.longitude,
        this.latitude,
        this.highlighted,
        this.price,
        this.hasRecurringDates,
        this.startDate,
        this.endDate,
        this.dateDetails,
        this.dates,
        this.images,
        this.links,
    });

    int id;
    List<CategoryElement> categories;
    Organizer organizer;
    String title;
    String description;
    String location;
    String longitude;
    String latitude;
    bool highlighted;
    String price;
    bool hasRecurringDates;
    DateTime startDate;
    DateTime endDate;
    String dateDetails;
    List<DateElement> dates;
    List<ImageElement> images;
    List<dynamic> links;

    factory Event.fromMap(Map<String, dynamic> json) => Event(
        id: json["id"],
        categories: List<CategoryElement>.from(json["categories"].map((x) => CategoryElement.fromMap(x))),
        organizer: Organizer.fromMap(json["organizer"]),
        title: json["title"],
        description: json["description"],
        location: json["location"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        highlighted: json["highlighted"],
        price: json["price"],
        hasRecurringDates: json["has_recurring_dates"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        dateDetails: json["date_details"] == null ? null : json["date_details"],
        dates: List<DateElement>.from(json["dates"].map((x) => DateElement.fromMap(x))),
        images: List<ImageElement>.from(json["images"].map((x) => ImageElement.fromMap(x))),
        links: List<dynamic>.from(json["links"].map((x) => x)),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "categories": List<dynamic>.from(categories.map((x) => x.toMap())),
        "organizer": organizer.toMap(),
        "title": title,
        "description": description,
        "location": location,
        "longitude": longitude,
        "latitude": latitude,
        "highlighted": highlighted,
        "price": price,
        "has_recurring_dates": hasRecurringDates,
        "start_date": "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "end_date": "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "date_details": dateDetails == null ? null : dateDetails,
        "dates": List<dynamic>.from(dates.map((x) => x.toMap())),
        "images": List<dynamic>.from(images.map((x) => x.toMap())),
        "links": List<dynamic>.from(links.map((x) => x)),
    };
}

class CategoryElement {
    CategoryElement({
        this.category,
    });

    CategoryCategory category;

    factory CategoryElement.fromMap(Map<String, dynamic> json) => CategoryElement(
        category: CategoryCategory.fromMap(json["category"]),
    );

    Map<String, dynamic> toMap() => {
        "category": category.toMap(),
    };
}

class CategoryCategory {
    CategoryCategory({
        this.name,
    });

    String name;

    factory CategoryCategory.fromMap(Map<String, dynamic> json) => CategoryCategory(
        name: json["name"],
    );

    Map<String, dynamic> toMap() => {
        "name": name,
    };
}

class DateElement {
    DateElement({
        this.date,
    });

    DateDate date;

    factory DateElement.fromMap(Map<String, dynamic> json) => DateElement(
        date: DateDate.fromMap(json["date"]),
    );

    Map<String, dynamic> toMap() => {
        "date": date.toMap(),
    };
}

class DateDate {
    DateDate({
        this.eventDate,
        this.timeStart,
        this.timeEnd,
    });

    DateTime eventDate;
    DateTime timeStart;
    DateTime timeEnd;

    factory DateDate.fromMap(Map<String, dynamic> json) => DateDate(
        eventDate: DateTime.parse(json["event_date"]),
        timeStart: DateTime.parse(json["time_start"]),
        timeEnd: json["time_end"] == null ? null : DateTime.parse(json["time_end"]),
    );

    Map<String, dynamic> toMap() => {
        "event_date": "${eventDate.year.toString().padLeft(4, '0')}-${eventDate.month.toString().padLeft(2, '0')}-${eventDate.day.toString().padLeft(2, '0')}",
        "time_start": timeStart.toIso8601String(),
        "time_end": timeEnd == null ? null : timeEnd.toIso8601String(),
    };
}

class ImageElement {
    ImageElement({
        this.image,
    });

    ImageImage image;

    factory ImageElement.fromMap(Map<String, dynamic> json) => ImageElement(
        image: ImageImage.fromMap(json["image"]),
    );

    Map<String, dynamic> toMap() => {
        "image": image.toMap(),
    };
}

class ImageImage {
    ImageImage({
        this.original,
        this.thumbnail,
        this.fullHd,
    });

    String original;
    String thumbnail;
    String fullHd;

    factory ImageImage.fromMap(Map<String, dynamic> json) => ImageImage(
        original: json["original"],
        thumbnail: json["thumbnail"],
        fullHd: json["full_hd"],
    );

    Map<String, dynamic> toMap() => {
        "original": original,
        "thumbnail": thumbnail,
        "full_hd": fullHd,
    };
}

class Organizer {
    Organizer({
        this.name,
        this.linkWebsite,
        this.linkFacebook,
        this.linkInstagram,
        this.linkTwitter,
        this.image,
    });

    String name;
    String linkWebsite;
    String linkFacebook;
    String linkInstagram;
    String linkTwitter;
    String image;

    factory Organizer.fromMap(Map<String, dynamic> json) => Organizer(
        name: json["name"],
        linkWebsite: json["link_website"],
        linkFacebook: json["link_facebook"],
        linkInstagram: json["link_instagram"],
        linkTwitter: json["link_twitter"],
        image: json["image"],
    );

    Map<String, dynamic> toMap() => {
        "name": name,
        "link_website": linkWebsite,
        "link_facebook": linkFacebook,
        "link_instagram": linkInstagram,
        "link_twitter": linkTwitter,
        "image": image,
    };
}
