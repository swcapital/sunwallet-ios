import SwiftUI

struct NewsSection: View {
    // MARK:- Properties
    let articles: [Article]
    
    // MARK:- Subviews
    private var header: some View {
        Text("News")
            .font(.title)
            .padding(16)
    }
    
    var body: some View {
        Section(header: header) {
            Divider()
            ForEach(self.articles) { article in
                HomeArticleCell(article: article)
                Divider()
            }
            
            DetailsCell(text: Text("View More Stories"))
            
            Divider()
        }
    }
}
