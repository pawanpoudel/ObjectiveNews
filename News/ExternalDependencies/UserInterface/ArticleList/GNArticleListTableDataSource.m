#import "GNArticleListTableDataSource.h"
#import "GNArticleCell.h"
#import "GNArticleLoadingErrorCell.h"
#import "UIView+LoadNib.h"
#import "NSFetchedResultsController+GNAdditions.h"

NSString * const GNDidSelectArticleNotification = @"GNDidSelectArticleNotification";

@interface GNArticleListTableDataSource ()

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation GNArticleListTableDataSource

#pragma mark - Configuring table view

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    self.tableView = tableView;
    
    if (self.shouldShowArticleLoadingError) {
        return 1;
    }
    
    NSArray *sections = self.fetchedResultsController.sections;
    return [sections[section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell = nil;
    
    if (self.shouldShowArticleLoadingError) {
        cell = [self articleLoadingErrorCell];
    } else {
        cell = [self articleCellAtIndexPath:indexPath];
    }
    
    return cell;
}

- (GNArticleLoadingErrorCell *)articleLoadingErrorCell {
    NSString *reuseId = [GNArticleLoadingErrorCell reuseIdentifier];
    GNArticleLoadingErrorCell *cell =
        (GNArticleLoadingErrorCell *)[self.tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (!cell) {
        cell = (GNArticleLoadingErrorCell *)[UIView loadViewFromNibName:[GNArticleLoadingErrorCell nibName]];
    }
    
    return cell;
}

- (GNArticleCell *)articleCellAtIndexPath:(NSIndexPath *)indexPath {
    GNArticleCell *cell = [self createArticleCell];
    [self configureArticleCell:cell
                   atIndexPath:indexPath];
    return cell;
}

- (GNArticleCell *)createArticleCell {
    NSString *reuseId = [GNArticleCell reuseIdentifier];
    GNArticleCell *cell = (GNArticleCell *)[self.tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (!cell) {
        cell = (GNArticleCell *)[UIView loadViewFromNibName:[GNArticleCell nibName]];
    }
    
    return cell;
}

- (void)configureArticleCell:(GNArticleCell *)cell
                 atIndexPath:(NSIndexPath *)indexPath
{
    GNArticle *article = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell setArticle:article];
}

#pragma mark - Computing cell height

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.shouldShowArticleLoadingError) {
        return [GNArticleLoadingErrorCell height];
    }
    
    return [GNArticleCell height];
}

#pragma mark - Handling cell tap

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GNArticle *article = [self.fetchedResultsController articleAtIndexPath:indexPath];
    NSNotification *notification = [NSNotification notificationWithName:GNDidSelectArticleNotification
                                                                 object:article];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
