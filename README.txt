Entain Tech Test - Neds Next To Go

The following is designed to be a summary of my approach to the task.

Architecture - Clean Architecture

The project will be laid out into UI, Domain and Data layer components.

UI Layer

The UI layer will have a View-ViewModel structure. This layer will contain an abstracted Information type(s) that are supplied by the lower-level UseCasesProvider. 

Domain Layer

The use cases is where all business logic resides. A use case contains a maximum of 1 publicly exposed function that supplies a abstract Model type from the data it receives from the lower-level RepositoryProvider, via a mapper.

Data Layer

The data layer is where the projects repositories can be found. The role of the repository is to fetch, update  etc from/to some external source - an API, database, content management system, some localised strings file etc. 

In the same way the Domain layer abstracts its data out to an Information Type, the repository will abstract out to a Domain layer Model type. More than this though, the Data layer will contain a special type of its own - what I call the response mapper - to ensure separation of the Responses decoding logic and the data useable at the higher-level Domain layer. 

Finally I will define an EndPoint protocol with default properties that wraps the HTTPURLRequest data up for supply to the Networking ‘module’. While my ‘in-production’ approach would be to write multiple different conformances in this way i..e other endpoints for caching, for different levels of auth (al sbsctracted out again here for auth and other crypto requirements), endpoints configured to work explicitly with retying - or combinations of each, for the purposes of this task I wlll st

Limitation: The Networking module is going to be incredibly simplistic. I would rather focus on the code that runs after we get the response, rather then during network calls setup for example.

________________________________________________________________________________


Doing things the above way helps to keep the following principles of CA design in check:

1. Higher level layers should have no knowledge of the inner workings of the lower levels and should make contact via a abstracted interface;
2. All business logic belongs in use cases
3. Everything is injectable, everything is mockable and therefore must be.

Navigation

I will handle the App's navigation through the use of Combine's PassthroughSubject and a NavigationActions enum type.

Dependencies

Obviously dependencies within the project should be frameworked or packaged out. For the purposes of this project I won’t commit to this time overhead, but I will still write modularised components access and the like as though they are a separated library, where necessary.

Unit tests

This is where the magic of clean architecture will kick in. While there is a bit of overhead in writing the mocks for the various layer components, the providers and the DependencyGraph itself, once done, writing further unit tests that use these same conoponents becomes trivial in terms of both complexity and unit test development hours overhead.

Limitation: The test suites and their capacity to scale is proportionate to the quality of the mocks that are written. For the purposes of this task I will write mocks that contain functionality only up to what I need to demonstrate the approach, in production the aim would be to cover every possible scenario.


Linting

I will use SwiftLint here and it will be added to the project as a build phase (although this should also be a Git Hook)

Limitation: I will use force unwrapping in unit tests. The reason I find this acceptable is because in the cases where it’s used, even to a junior developers eyes, there is no possibility for instability. It’s used this way simply to promote more concise, optional-free expression. 

Best Practice

Apart from what I’ve outlined above in amongst my reasoning, I don’t really have much to say here. The conversation about best practice should be had in review while reading the code, I know I have learned best practice not by being told what best practice is directly, but by reading code that exhibits it.

