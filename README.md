# FZRealm

A collection of Extensions to Realm.

It provides CustomPersistable conformance to many types (like URL, CGRect, CGPoint, CGSize and CMTime) so that they can be be used Realm Object properties.

## RealmObject protocol
 A protocol that provides additional functionality to Realm Objects conforming to it (like saving, editing or deleting an object or fetching all).

```
class Video: Object, RealmObject {
    @Persisted var url: URL
    @Persisted var date: URL
    @Persisted var dimensions: CGSize
}

let videos = try Video.all() // All video objects
let videos = try Video.all(where: {$0.date < someDate }) // All video objects before someDate
try Video.deleteAll() // Deletes all video objects

let video = Video() // new video object
try video.save() // save video
try video.edit { // edits video
    $0.date = newDate
    $0.url = newURL
}
try video.delete() // delets video
```
