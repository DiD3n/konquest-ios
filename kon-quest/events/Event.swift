import Foundation

struct Event: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let description: String
    let date: String
    let location: String
    let type: String
    let maxParticipants: Int
    let imageUrl: String?
    let geometry: String
    let quests: [Quest]?
    let weather: Weather?
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
    
    static let mock = Event(
        id: 3,
        name: "Moricon",
        description: "Comics & Games",
        date: "2025-09-10",
        location: "Warsaw",
        type: "expo",
        maxParticipants: 3000,
        imageUrl: "/static/images/moricon.jpg",
        geometry: """
        {
          "type": "FeatureCollection",
          "features": [
            {
              "type": "Feature",
              "properties": { "name": "MTP Poznań" },
              "geometry": {
                "type": "Polygon",
                "coordinates": [[
                  [16.900, 52.400],
                  [16.917, 52.400],
                  [16.917, 52.410],
                  [16.900, 52.410],
                  [16.900, 52.400]
                ]]
              }
            }
          ]
        }
        """,
        quests: [
            Quest(id: 11, eventId: 3, type: .walk_to, name: "Selfie z Cosplayerem", description: "Zrób selfie z dowolnym cosplayerem", metric: "Zdjęcie", xp: 130, points: nil),
            Quest(id: 12, eventId: 3, type: .walk_to, name: "Znajdź stoisko X", description: "Odszukaj i odwiedź stoisko X", metric: "Stoisko X", xp: 80, points: nil)
        ],
        weather: Weather(
            latitude: 53.114258,
            longitude: 23.159271,
            generationtime_ms: 0.07045269012451172,
            utc_offset_seconds: 0,
            timezone: "GMT",
            timezone_abbreviation: "GMT",
            elevation: 152,
            current_units: CurrentUnits(
                time: "iso8601",
                interval: "seconds",
                temperature_2m: "°C",
                wind_speed_10m: "km/h",
                weathercode: "wmo code"
            ),
            current: Current(
                time: "2025-06-20T20:15",
                interval: 900,
                temperature_2m: 14.9,
                wind_speed_10m: 16.9,
                weathercode: 0
            )
        )
    )
    
    static let mock2 = Event(
        id: 2,
        name: "Sample Eventer",
        description: "This is a preview of an eventer card.",
        date: "2025-06-25",
        location: "Wroclaw",
        type: "game",
        maxParticipants: 69,
        imageUrl: nil,
        geometry: """
          {
            "type": "FeatureCollection",
            "features": [
              {
                "type": "Feature",
                "properties": {},
                "geometry": {
                  "coordinates": [
                    [
                      [
                        16.91166646736832,
                        52.406251105627774
                      ],
                      [
                        16.911284511852358,
                        52.40629541454982
                      ],
                      [
                        16.911262210246036,
                        52.40620303722531
                      ],
                      [
                        16.911167532890914,
                        52.40621208603926
                      ],
                      [
                        16.911187324871378,
                        52.4062628679159
                      ],
                      [
                        16.909326047241308,
                        52.406489442111535
                      ],
                      [
                        16.909297478565918,
                        52.40639896397346
                      ],
                      [
                        16.908985662836017,
                        52.40642474644392
                      ],
                      [
                        16.909004398959667,
                        52.406508699940616
                      ],
                      [
                        16.9087554267457,
                        52.40651775809417
                      ],
                      [
                        16.908721403603465,
                        52.406409282403615
                      ],
                      [
                        16.908613168114414,
                        52.40641928900402
                      ],
                      [
                        16.908522918685037,
                        52.40614213083671
                      ],
                      [
                        16.908377495574257,
                        52.40615077266307
                      ],
                      [
                        16.90756690814871,
                        52.40623967528148
                      ],
                      [
                        16.907633164240877,
                        52.406447880867034
                      ],
                      [
                        16.90700418927463,
                        52.40651025357249
                      ],
                      [
                        16.906986064271848,
                        52.40640541922107
                      ],
                      [
                        16.90678983658998,
                        52.405647670771685
                      ],
                      [
                        16.906311446850395,
                        52.40570560179924
                      ],
                      [
                        16.905739618446717,
                        52.40372048714289
                      ],
                      [
                        16.90406240139839,
                        52.40383001837981
                      ],
                      [
                        16.904025452459734,
                        52.40363558587083
                      ],
                      [
                        16.903962744241625,
                        52.403632442749426
                      ],
                      [
                        16.903875375819723,
                        52.40318334079166
                      ],
                      [
                        16.904151249815214,
                        52.40316123614264
                      ],
                      [
                        16.904089302114443,
                        52.40292776920475
                      ],
                      [
                        16.9038263075916,
                        52.40294559726502
                      ],
                      [
                        16.903740462747066,
                        52.40249223327001
                      ],
                      [
                        16.903688099736968,
                        52.40241193784914
                      ],
                      [
                        16.903819694359044,
                        52.401964690735554
                      ],
                      [
                        16.904158700978314,
                        52.40200272584002
                      ],
                      [
                        16.904405593588535,
                        52.40203304049052
                      ],
                      [
                        16.904377892954557,
                        52.4017058620301
                      ],
                      [
                        16.905507019206652,
                        52.40096895868058
                      ],
                      [
                        16.906426138936382,
                        52.40152268054817
                      ],
                      [
                        16.9069782675995,
                        52.40157743029769
                      ],
                      [
                        16.90738340282337,
                        52.40181401520147
                      ],
                      [
                        16.907495181857882,
                        52.40200987469996
                      ],
                      [
                        16.909322778608498,
                        52.403031569350645
                      ],
                      [
                        16.90919885228979,
                        52.40311026771576
                      ],
                      [
                        16.909370142365702,
                        52.40316685702689
                      ],
                      [
                        16.90991524991665,
                        52.40309010541279
                      ],
                      [
                        16.910311882152257,
                        52.40416353595617
                      ],
                      [
                        16.910723361459247,
                        52.404104487969676
                      ],
                      [
                        16.910767806045783,
                        52.40420398060073
                      ],
                      [
                        16.910808967011576,
                        52.40419676619851
                      ],
                      [
                        16.91091566650269,
                        52.40453689761162
                      ],
                      [
                        16.910870730561328,
                        52.40453988044791
                      ],
                      [
                        16.910884625128233,
                        52.40459398823231
                      ],
                      [
                        16.911100003828324,
                        52.404576354799644
                      ],
                      [
                        16.91166646736832,
                        52.406251105627774
                      ]
                    ]
                  ],
                  "type": "Polygon"
                }
              }
            ]
          }
        """,
        quests: [],
        weather: nil
    )
}

struct Weather: Codable, Equatable {
    let latitude: Double
    let longitude: Double
    let generationtime_ms: Double
    let utc_offset_seconds: Int
    let timezone: String
    let timezone_abbreviation: String
    let elevation: Int
    let current_units: CurrentUnits
    let current: Current
}

struct CurrentUnits: Codable, Equatable {
    let time: String
    let interval: String
    let temperature_2m: String
    let wind_speed_10m: String
    let weathercode: String
}

struct Current: Codable, Equatable {
    let time: String
    let interval: Int
    let temperature_2m: Double
    let wind_speed_10m: Double
    let weathercode: Int
}
