import Foundation

struct NewsItem: Identifiable, Decodable {
    var id: Int
    var headline: String?
    var summary: String?
    var image: String?
    var url: String?
    var source: String?
    var datetime: Date?
    
    private enum CodingKeys: String, CodingKey {
        case id, headline, summary, image, url, source, datetime
    }
    
    init(id: Int, headline: String?, summary: String?, image: String?, url: String?, source: String?, datetime: Date?) {
        self.id = id
        self.headline = headline
        self.summary = summary
        self.image = image
        self.url = url
        self.source = source
        self.datetime = datetime
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        headline = try container.decodeIfPresent(String.self, forKey: .headline)
        summary = try container.decodeIfPresent(String.self, forKey: .summary)
        image = try container.decodeIfPresent(String.self, forKey: .image)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        source = try container.decodeIfPresent(String.self, forKey: .source)
        
        if let timestamp = try container.decodeIfPresent(Double.self, forKey: .datetime) {
            datetime = Date(timeIntervalSince1970: timestamp)
        }
    }
}
