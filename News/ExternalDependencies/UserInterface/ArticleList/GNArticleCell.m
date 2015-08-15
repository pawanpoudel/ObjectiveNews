#import "GNArticleCell.h"
#import "GNArticle.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <FormatterKit/TTTTimeIntervalFormatter.h>

@interface GNArticleCell()

@property (nonatomic) GNArticle *article;
@property (weak, nonatomic) IBOutlet UILabel *publishedDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *publisherLabel;
@property (weak, nonatomic) IBOutlet UIButton *titleButton;
@property (weak, nonatomic) IBOutlet UIImageView *articleImageView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic) TTTTimeIntervalFormatter *timeIntervalFormatter;

@end

@implementation GNArticleCell

#pragma mark - Accessors

- (TTTTimeIntervalFormatter *)timeIntervalFormatter {
    if (!_timeIntervalFormatter) {
        _timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
        _timeIntervalFormatter.leastSignificantUnit = NSCalendarUnitSecond;
    }
    
    return _timeIntervalFormatter;
}

#pragma mark - Configuring cell

+ (CGFloat)height {
    return 115.0f;
}

- (void)awakeFromNib {
    [self addBordersToContainerView];
    [self makeTitleTextMultiLine];
}

- (void)addBordersToContainerView {
    self.containerView.layer.cornerRadius = 3.0f;
    self.containerView.layer.borderWidth = 0.5f;
    self.containerView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
}

- (void)makeTitleTextMultiLine {
    self.titleButton.titleLabel.numberOfLines = 0;
}

#pragma mark - Updating cell content

- (void)setArticle:(GNArticle *)article {
    _article = article;

    self.publisherLabel.text = article.publisher;
    self.publishedDateLabel.text = [self.timeIntervalFormatter stringForTimeIntervalFromDate:[NSDate date]
                                                                                      toDate:article.publishedDate];
    [self.titleButton setTitle:article.title
                      forState:UIControlStateNormal];
    
    [self.articleImageView sd_setImageWithURL:[NSURL URLWithString:article.imageUrl]
                             placeholderImage:[UIImage imageNamed:@"articlePlaceholderImage"]];
}

@end
