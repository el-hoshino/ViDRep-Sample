# ViDRep-Sample (Name subject to change)

[![Xcode](https://img.shields.io/badge/Xcode-12.5-blue.svg)](https://developer.apple.com/xcode)

ViDRep<a id="q_name" href= "#a_name"><sup>1</sup></a> is an experimental architecture designed for SwiftUI.

This is a sample project to show how to build an app using ViDRep. With this sample app, you're able to generate some cat images with any text (fewer than 10 characters) on it, and if you like that picture you can also save it to your device. Big thanks to [Cataas](https://cataas.com/) :smiling_face_with_three_hearts:

![Sample App Screen](README_Images/CatSaysHi.gif)

## Why another new architecture?

Apple introduced SwiftUI in 2019, which could be considered as the replacement of the legacy UIKit framework. But unlike UIKit which has Cocoa-MVC as the recommended architecture, SwiftUI doesn't have any *Official* architecture so far.

There are already many architectures that can be used with SwiftUI, like MVVM, VIPER, Redux, SwifTEA, TCA, etc., but unfortunately there isn't a killer-architecture yet, all the architectures above has some drawbacks. For instance a traditional MVVM relies heavily on bidirectional data-binding, which is hard to read or maintain; VIPER is a good choice if you have a huge project or you're working with a big team, but obviously over-kill for small projects; Redux is also a good choice because it shares the same **Single Source of Truth** princeple with SwiftUI, but it also requires too many components which makes it hard to master. So far TCA is becoming more and more popular, but it requires additional library.

So I decided to create a new architecture when working on my next SwiftUI project, with goals below:

1. Unidirectional data flow.

    Data flow is one of the most important keys in programming. An easy-to-track data flow makes your app easy to maintain & debug. And obviously, comparing with bidirectional data flow, unidirectional data flow is much easier to track because the condition is very simple. So the new architecture's data flow should be unidirectional.

2. Single Source of Truth.

    This is also SwiftUI's princeple, so no reason to ignore it. 

3. Make use of `ObservableObject` in Foundation
    
    Many people like using reactive frameworks like RxSwift or Combine. Sure they are very good tools to track data changes, but SwiftUI can handle change notifications from `@Published` variables declared in an `ObservableObject`, very simple. So why not just use them.

4. Testable

    No doubts how important unit tests are. So definitely components holding business logics must be designed to be easy to test.

5. Scalable

    The scale of projects may change in the future, so it'd be nice if the architecture has some scalability.

## Introducing ViDRep

ViDRep is the architecture come out to achieve the goals above. I'll explain how but first let's take a look at the diagram of ViDRep:

![ViDRep diagram 1](README_Images/ViDRep.001.png)

You may notice that ViDRep looks just like an MVC (**NOT** CocoaMVC) pattern. That's because it IS inspired by the original MVC pattern, and it works just like the original MVC pattern: A view fires an action, the controller handles that action and updates the data model, and the data model's update triggers the view's re-rendering. It's a powerful yet very simple pattern.

But if dig deeper you'll find it's not quite the same as the original MVC. In the original MVC pattern, it's controller who fires the action, and it's model itself who handles the action.

Also if you have experiences on Redux you may find familiar on the names like `Dispatcher` and `Reducer`, which have never appeared on a traditional MVC pattern. Actually this is also where `ViDRep` come from. `Vi` stands for `View`, `D` stands for `Dispatcher`, and `Rep` stands for `Repository`.

So, what do all the components do in ViDRep?

### ~~View~~Scene

Under View layer there are 3 types of components: Scenes, ViewComponents and ViewModifiers. ViewModifiers are just `SwiftUI.ViewModifier`s. A Scene is a whole page diplayed in your window, and ViewComponents are elements in that scene, like a `Button`. Both Scenes and ViewComponents are `SwiftUI.View`s

All types under View layer only describes how a view should be rendered. Some of them may also fire actions, like buttons, but they don't control how the action should change the data models.

A `Scene` will have 2 types of dependencies: a `Dispatcher` and a `Repository`. `Dispatcher` should handle possible actions that may be fired from the view, and `Repository` should present the data required by the view. It should also be `ObservableObject` so `View` can know when to update the rendering.

In addition, it's not represented in the graph above but it may also have a `RouterDelegate` if you wish to leave routing process to a `Router`.

### Dispatcher

A `Dispatcher` should handle events fired from a `Scene`, by asking the reducer to generate a new data (or a state if you're familiar with Redux) from given event, and then stores the new data into `Repository`.

A `Dispatcher` may have 4 types of dependencies: a `Reducer`, a `Repository`, an `APIClient` and a `Database`. `Reducer`s should generate new data from given data and action, or on other words, should handle the business logic with pure functions. A `Repository` should be able to store the new data. `APIClient` and `Database` are also held by `Dispatcher`s because they're not considered as the *Source of Truth*. As the result, handling data from them are `Dispatcher`s' responsibility.

If the business logics are too simple, or the scale of the project/team is too small, you may also choose to contain the reducer logics, network logics and persistance logics inside the `Dispatcher` to get rid of `Reducer` `APIClient` and `Database`. This could make writing unit tests a tiny little bit difficult comparing with having the independent `Reducer` component, but it takes much fewer lines of code on the other hand.

### Reducer

A `Reducer` should handle the business logics by generating new data from given data and action. A `Reducer` should be pure functions with no states or side effects, so it'd be very easy to write unit tests.

`Reducer` should have no dependencies. This also makes it easy to write unit tests since you don't need any mock components.

### Repository

A `Repository` is the app's `Single Source of Truth`. It should just store data from `Dispatcher`, and should just store the data as-is, and there should be only **ONE SINGLE** repository.

`Repository` should be `ObservableObject` so a `View` can get notified when some data will change.

`Repository` should have no dependencies.

### Database

`Database` is where data get persistent. A typical `Databse` is `UserDefaults`.

`Database` should have no dependencies.

### APIClient

`APIClient` is the component communicating with servers to get/post data. Since it's basically working asynchronously, asynchronous event handling libraries like `Combine` or `PromiseKit` may be helpful, but you may still choose callbacks to handle the asynchronous data process.

`APIClient` should have no dependences.

### Router

`Router` isn't appeared in the graph above, it's optional that you may choose wether or not to have a `Router`. In this sample project routings are managed by a `Router`.

A typical SwiftUI design is not easy to manage all routing logics outside a `View`, but with some workarounds it is possible. Please check [this repo](https://github.com/el-hoshino/SwiftUI-RouterDemo) to find out how it works.

### Resolver

`Resolver` isn't appeared in the graph either, and it's also optional. If you choose to make one, it should handle all the DIs in your project. In this sample project all components are generated by a `Resolver`.

## Why ViDRep

Now let's see how this `ViDRep` achieves the goal I listed above.

1. Unidirectional data flow.

    Since it's inspired from MVC and Redux, it's obvously unidirectional. Data goes from `View`, to `Controller`, to `Model`, and at last back to `View` again.

2. Single Source of Truth

    In ViDRep there should always be only one single `Repository`, and the `Repository` is the single source of truth.

3. Make use of `ObservableObject` in Foundation
    
    In ViDRep, `Repository` is `ObservableObject`, which `SwiftUI.View` can get notified when it's going to change. This makes it really easy to maintain the `View` code since you don't need to care about the reactive concepts like streams.

4. Testable

    Business logics are all concentrated in `Reducer`s. And since `Reducer`s are stateless and only contain pure functions, it's very easy to write unit tests.

5. Scalable
    
    Unlike Redux or VIPER, some components in ViDRep are not essential, e.g. `Reducer`s and `Database`s. And even if you choose not to make a `Reducer`, business logics in `Dispatcher`s are still not difficult to test.

## Any disadvantages?

Every architecture has its own disadvantages, and ViDRep is not excluded. One of the big disadvantages is that since it should only have one single `Repository`, if there are too many states held by app, the `Repository` may become massive.

Another issue you may meet is if you have complex presentation logics, your `View` may become fat since ViDRep isn't designed to have a `ViewModel`. You may still create a `ViewModel` if you like, but 1) if your `ViewModel` only handles the data sent from `Repository`, `View` won't have the original data type, and that may have difficulty when trying to send actions with data to `Dispatcher`; and 2) if your `ViewModel` handles both data sent from `Repository` and data sent to `Dispatcher` that means you're having a bidirectional data binding between `View` and `ViewModel`, which you may need cautious when handling the data flow.

## Notes

<ul>
<li id="a_name"><a href="#q_name">1:</a> The correct spell is `ViDRep`, but case-mistakes like `Vidrep` or `vidrep` are also acceptable. Anyway `ViDRep` is just a tentative name.</li>
</ul>
