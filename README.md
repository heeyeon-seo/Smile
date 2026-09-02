# Smile

A simple Flutter app that shows age-appropriate etiquette and life-skill tips
for kids, grouped by grade level (kindergarten through 6th grade). Pick a grade,
then browse tips for good manners or everyday skills like tying shoes, doing
laundry, or managing a small budget.

Built with Flutter. Not released yet.

## Why I built this

I was a PAL (Peer Assistance Leadership) in my junior and senior year of high
school, and I saw a lot of kids who weren't getting the attention or guidance
at home they needed for their social lives — things as basic as manners or
everyday life skills. One of the kids I worked with didn't know how to say
sorry to a friend, and it turned into a real fight. That stuck with me, and I
decided to build something that could actually help, using the one skill I had
at the time: building apps.

This was one of my first apps, built while I was still a beginner at coding.
I'm planning to expand it later with more content and better visuals, with the
goal of actually publishing it so it can help more kids.

## How it works

The app opens with a short animated splash screen, then asks which grade the
child is in. Based on that, it shows two lists: etiquette tips (manners,
social behavior) and life tips (everyday skills), both tailored to that age
group.

## Tech stack

Flutter only — no backend, no external packages beyond `cupertino_icons`.
All content (grade tips) is stored directly in the code as simple maps, and
all images are local assets. The whole app is a single `main.dart` file.

## Getting started

```bash
git clone https://github.com/heeyeon-seo/smile.git
cd smile
flutter pub get
flutter run
```

## What's next

- [ ] Move tip content out of the code and into a JSON or Firestore source
- [ ] Add a way to go back and pick a different grade without restarting
- [ ] Add more grades / tip categories
- [ ] Refresh the visuals and add more content before publishing

## Author

Heeyeon Seo — [@heeyeon-seo](https://github.com/heeyeon-seo)

---

*Code comments are in Korean.*
