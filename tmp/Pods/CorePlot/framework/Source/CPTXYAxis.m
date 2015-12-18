#import "CPTXYAxis.h"

#import "CPTConstraints.h"
#import "CPTFill.h"
#import "CPTLimitBand.h"
#import "CPTLineCap.h"
#import "CPTLineStyle.h"
#import "CPTMutablePlotRange.h"
#import "CPTPlotArea.h"
#import "CPTPlotSpace.h"
#import "CPTUtilities.h"
#import "CPTXYPlotSpace.h"
#import "NSCoderExtensions.h"
#import <tgmath.h>

/// @cond
@interface CPTXYAxis()

-(void)drawTicksInContext:(nonnull CGContextRef)context atLocations:(nullable CPTNumberSet)locations withLength:(CGFloat)length inRange:(nullable CPTPlotRange *)labeledRange isMajor:(BOOL)major;

-(void)orthogonalCoordinateViewLowerBound:(nonnull CGFloat *)lower upperBound:(nonnull CGFloat *)upper;
-(CGPoint)viewPointForOrthogonalCoordinate:(nullable NSNumber *)orthogonalCoord axisCoordinate:(nullable NSNumber *)coordinateValue;

@end

/// @endcond

#pragma mark -

/**
 *  @brief A 2-dimensional cartesian (X-Y) axis class.
 **/
@implementation CPTXYAxis

/** @property NSNumber *orthogonalPosition
 *  @brief The data coordinate value where the axis crosses the orthogonal axis.
 *  If the @ref axisConstraints is non-nil, the constraints take priority and this property is ignored.
 *  @see @ref axisConstraints
 **/
@synthesize orthogonalPosition;

/** @property CPTConstraints *axisConstraints
 *  @brief The constraints used when positioning relative to the plot area.
 *  If @nil (the default), the axis is fixed relative to the plot space coordinates,
 *  crossing the orthogonal axis at @ref orthogonalPosition and moves only
 *  whenever the plot space ranges change.
 *  @see @ref orthogonalPosition
 **/
@synthesize axisConstraints;

#pragma mark -
#pragma mark Init/Dealloc

/// @name Initialization
/// @{

/** @brief Initializes a newly allocated CPTXYAxis object with the provided frame rectangle.
 *
 *  This is the designated initializer. The initialized layer will have the following properties:
 *  - @ref orthogonalPosition = @num{0}
 *  - @ref axisConstraints = @nil
 *
 *  @param newFrame The frame rectangle.
 *  @return The initialized CPTXYAxis object.
 **/
-(instancetype)initWithFrame:(CGRect)newFrame
{
    if ( (self = [super initWithFrame:newFrame]) ) {
        orthogonalPosition = @0.0;
        axisConstraints    = nil;
        self.tickDirection = CPTSignNone;
    }
    return self;
}

/// @}

/// @cond

-(instancetype)initWithLayer:(id)layer
{
    if ( (self = [super initWithLayer:layer]) ) {
        CPTXYAxis *theLayer = (CPTXYAxis *)layer;

        orthogonalPosition = theLayer->orthogonalPosition;
        axisConstraints    = theLayer->axisConstraints;
    }
    return self;
}

/// @endcond

#pragma mark -
#pragma mark NSCoding Methods

/// @cond

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];

    [coder encodeObject:self.orthogonalPosition forKey:@"CPTXYAxis.orthogonalPosition"];
    [coder encodeObject:self.axisConstraints forKey:@"CPTXYAxis.axisConstraints"];
}

-(instancetype)initWithCoder:(NSCoder *)coder
{
    if ( (self = [super initWithCoder:coder]) ) {
        orthogonalPosition = [coder decodeObjectForKey:@"CPTXYAxis.orthogonalPosition"];
        axisConstraints    = [coder decodeObjectForKey:@"CPTXYAxis.axisConstraints"];
    }
    return self;
}

/// @endcond

#pragma mark -
#pragma mark Coordinate Transforms

/// @cond

-(void)orthogonalCoordinateViewLowerBound:(CGFloat *)lower upperBound:(CGFloat *)upper
{
    CPTCoordinate orthogonalCoordinate = CPTOrthogonalCoordinate(self.coordinate);
    CPTXYPlotSpace *xyPlotSpace        = (CPTXYPlotSpace *)self.plotSpace;
    CPTPlotRange *orthogonalRange      = [xyPlotSpace plotRangeForCoordinate:orthogonalCoordinate];

    NSAssert(orthogonalRange != nil, @"The orthogonalRange was nil in orthogonalCoordinateViewLowerBound:upperBound:");

    CGPoint lowerBoundPoint = [self viewPointForOrthogonalCoordinate:orthogonalRange.location axisCoordinate:@0];
    CGPoint upperBoundPoint = [self viewPointForOrthogonalCoordinate:orthogonalRange.end axisCoordinate:@0];

    switch ( self.coordinate ) {
        case CPTCoordinateX:
            *lower = lowerBoundPoint.y;
            *upper = upperBoundPoint.y;
            break;

        case CPTCoordinateY:
            *lower = lowerBoundPoint.x;
            *upper = upperBoundPoint.x;
            break;

        default:
            *lower = NAN;
            *upper = NAN;
            break;
    }
}

-(CGPoint)viewPointForOrthogonalCoordinate:(NSNumber *)orthogonalCoord axisCoordinate:(NSNumber *)coordinateValue
{
    CPTCoordinate myCoordinate         = self.coordinate;
    CPTCoordinate orthogonalCoordinate = CPTOrthogonalCoordinate(myCoordinate);

    NSDecimal plotPoint[2];

    plotPoint[myCoordinate]         = coordinateValue.decimalValue;
    plotPoint[orthogonalCoordinate] = orthogonalCoord.decimalValue;

    CPTPlotArea *thePlotArea = self.plotArea;

    return [self convertPoint:[self.plotSpace plotAreaViewPointForPlotPoint:plotPoint numberOfCoordinates:2] fromLayer:thePlotArea];
}

-(CGPoint)viewPointForCoordinateValue:(NSNumber *)coordinateValue
{
    CGPoint point = [self viewPointForOrthogonalCoordinate:self.orthogonalPosition
                                            axisCoordinate:coordinateValue];

    CPTConstraints *theAxisConstraints = self.axisConstraints;

    if ( theAxisConstraints ) {
        CGFloat lb, ub;
        [self orthogonalCoordinateViewLowerBound:&lb upperBound:&ub];
        CGFloat constrainedPosition = [theAxisConstraints positionForLowerBound:lb upperBound:ub];

        switch ( self.coordinate ) {
            case CPTCoordinateX:
                point.y = constrainedPosition;
                break;

            case CPTCoordinateY:
                point.x = constrainedPosition;
                break;

            default:
                break;
        }
    }

    if ( isnan(point.x) || isnan(point.y) ) {
        NSLog( @"[CPTXYAxis viewPointForCoordinateValue:%@] was %@", coordinateValue, CPTStringFromPoint(point) );

        if ( isnan(point.x) ) {
            point.x = CPTFloat(0.0);
        }
        if ( isnan(point.y) ) {
            point.y = CPTFloat(0.0);
        }
    }

    return point;
}

/// @endcond

#pragma mark -
#pragma mark Drawing

/// @cond

-(void)drawTicksInContext:(CGContextRef)context atLocations:(CPTNumberSet)locations withLength:(CGFloat)length inRange:(CPTPlotRange *)labeledRange isMajor:(BOOL)major
{
    CPTLineStyle *lineStyle = (major ? self.majorTickLineStyle : self.minorTickLineStyle);

    if ( !lineStyle ) {
        return;
    }

    CGFloat lineWidth = lineStyle.lineWidth;

    CPTAlignPointFunction alignmentFunction = NULL;
    if ( ( self.contentsScale > CPTFloat(1.0) ) && (round(lineWidth) == lineWidth) ) {
        alignmentFunction = CPTAlignIntegralPointToUserSpace;
    }
    else {
        alignmentFunction = CPTAlignPointToUserSpace;
    }

    [lineStyle setLineStyleInContext:context];
    CGContextBeginPath(context);

    for ( NSDecimalNumber *tickLocation in locations ) {
        if ( labeledRange && ![labeledRange containsNumber:tickLocation] ) {
            continue;
        }

        // Tick end points
        CGPoint baseViewPoint  = [self viewPointForCoordinateValue:tickLocation];
        CGPoint startViewPoint = baseViewPoint;
        CGPoint endViewPoint   = baseViewPoint;

        CGFloat startFactor = CPTFloat(0.0);
        CGFloat endFactor   = CPTFloat(0.0);
        switch ( self.tickDirection ) {
            case CPTSignPositive:
                endFactor = CPTFloat(1.0);
                break;

            case CPTSignNegative:
                endFactor = CPTFloat(-1.0);
                break;

            case CPTSignNone:
                startFactor = CPTFloat(-0.5);
                endFactor   = CPTFloat(0.5);
                break;
        }

        switch ( self.coordinate ) {
            case CPTCoordinateX:
                startViewPoint.y += length * startFactor;
                endViewPoint.y   += length * endFactor;
                break;

            case CPTCoordinateY:
                startViewPoint.x += length * startFactor;
                endViewPoint.x   += length * endFactor;
                break;

            default:
                NSLog(@"Invalid coordinate in [CPTXYAxis drawTicksInContext:]");
        }

        startViewPoint = alignmentFunction(context, startViewPoint);
        endViewPoint   = alignmentFunction(context, endViewPoint);

        // Add tick line
        CGContextMoveToPoint(context, startViewPoint.x, startViewPoint.y);
        CGContextAddLineToPoint(context, endViewPoint.x, endViewPoint.y);
    }
    // Stroke tick line
    [lineStyle strokePathInContext:context];
}

-(void)renderAsVectorInContext:(CGContextRef)context
{
    if ( self.hidden ) {
        return;
    }

    [super renderAsVectorInContext:context];

    [self relabel];

    CPTPlotRange *thePlotRange    = [self.plotSpace plotRangeForCoordinate:self.coordinate];
    CPTMutablePlotRange *range    = [thePlotRange mutableCopy];
    CPTPlotRange *theVisibleRange = self.visibleRange;
    if ( theVisibleRange ) {
        [range intersectionPlotRange:theVisibleRange];
    }

    CPTMutablePlotRange *labeledRange = nil;

    switch ( self.labelingPolicy ) {
        case CPTAxisLabelingPolicyNone:
        case CPTAxisLabelingPolicyLocationsProvided:
            labeledRange = range;
            break;

        default:
            break;
    }

    // Ticks
    [self drawTicksInContext:context atLocations:self.minorTickLocations withLength:self.minorTickLength inRange:labeledRange isMajor:NO];
    [self drawTicksInContext:context atLocations:self.majorTickLocations withLength:self.majorTickLength inRange:labeledRange isMajor:YES];

    // Axis Line
    CPTLineStyle *theLineStyle = self.axisLineStyle;
    CPTLineCap *minCap         = self.axisLineCapMin;
    CPTLineCap *maxCap         = self.axisLineCapMax;

    if ( theLineStyle || minCap || maxCap ) {
        // If there is a separate axis range given then restrict the axis to that range, overriding the visible range
        // given for grid lines and ticks.
        CPTPlotRange *theVisibleAxisRange = self.visibleAxisRange;
        if ( theVisibleAxisRange ) {
            range = [theVisibleAxisRange mutableCopy];
        }
        CPTAlignPointFunction alignmentFunction = CPTAlignPointToUserSpace;
        if ( theLineStyle ) {
            CGFloat lineWidth = theLineStyle.lineWidth;
            if ( ( self.contentsScale > CPTFloat(1.0) ) && (round(lineWidth) == lineWidth) ) {
                alignmentFunction = CPTAlignIntegralPointToUserSpace;
            }

            CGPoint startViewPoint = alignmentFunction(context, [self viewPointForCoordinateValue:range.location]);
            CGPoint endViewPoint   = alignmentFunction(context, [self viewPointForCoordinateValue:range.end]);
            [theLineStyle setLineStyleInContext:context];
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, startViewPoint.x, startViewPoint.y);
            CGContextAddLineToPoint(context, endViewPoint.x, endViewPoint.y);
            [theLineStyle strokePathInContext:context];
        }

        CGPoint axisDirection = CGPointZero;
        if ( minCap || maxCap ) {
            switch ( self.coordinate ) {
                case CPTCoordinateX:
                    axisDirection = ( range.lengthDouble >= CPTFloat(0.0) ) ? CPTPointMake(1.0, 0.0) : CPTPointMake(-1.0, 0.0);
                    break;

                case CPTCoordinateY:
                    axisDirection = ( range.lengthDouble >= CPTFloat(0.0) ) ? CPTPointMake(0.0, 1.0) : CPTPointMake(0.0, -1.0);
                    break;

                default:
                    break;
            }
        }

        if ( minCap ) {
            CGPoint viewPoint = alignmentFunction(context, [self viewPointForCoordinateValue:range.minLimit]);
            [minCap renderAsVectorInContext:context atPoint:viewPoint inDirection:CPTPointMake(-axisDirection.x, -axisDirection.y)];
        }

        if ( maxCap ) {
            CGPoint viewPoint = alignmentFunction(context, [self viewPointForCoordinateValue:range.maxLimit]);
            [maxCap renderAsVectorInContext:context atPoint:viewPoint inDirection:axisDirection];
        }
    }
}

/// @endcond

#pragma mark -
#pragma mark Grid Lines

/// @cond

-(void)drawGridLinesInContext:(CGContextRef)context isMajor:(BOOL)major
{
    CPTLineStyle *lineStyle = (major ? self.majorGridLineStyle : self.minorGridLineStyle);

    if ( lineStyle ) {
        [super renderAsVectorInContext:context];

        [self relabel];

        CPTPlotSpace *thePlotSpace           = self.plotSpace;
        CPTNumberSet locations               = (major ? self.majorTickLocations : self.minorTickLocations);
        CPTCoordinate selfCoordinate         = self.coordinate;
        CPTCoordinate orthogonalCoordinate   = CPTOrthogonalCoordinate(selfCoordinate);
        CPTMutablePlotRange *orthogonalRange = [[thePlotSpace plotRangeForCoordinate:orthogonalCoordinate] mutableCopy];
        CPTPlotRange *theGridLineRange       = self.gridLinesRange;
        CPTMutablePlotRange *labeledRange    = nil;

        switch ( self.labelingPolicy ) {
            case CPTAxisLabelingPolicyNone:
            case CPTAxisLabelingPolicyLocationsProvided:
            {
                labeledRange = [[self.plotSpace plotRangeForCoordinate:self.coordinate] mutableCopy];
                CPTPlotRange *theVisibleRange = self.visibleRange;
                if ( theVisibleRange ) {
                    [labeledRange intersectionPlotRange:theVisibleRange];
                }
            }
            break;

            default:
                break;
        }

        if ( theGridLineRange ) {
            [orthogonalRange intersectionPlotRange:theGridLineRange];
        }

        CPTPlotArea *thePlotArea = self.plotArea;
        NSDecimal startPlotPoint[2];
        NSDecimal endPlotPoint[2];
        startPlotPoint[orthogonalCoordinate] = orthogonalRange.locationDecimal;
        endPlotPoint[orthogonalCoordinate]   = orthogonalRange.endDecimal;
        CGPoint originTransformed = [self convertPoint:self.bounds.origin fromLayer:thePlotArea];

        CGFloat lineWidth = lineStyle.lineWidth;

        CPTAlignPointFunction alignmentFunction = NULL;
        if ( ( self.contentsScale > CPTFloat(1.0) ) && (round(lineWidth) == lineWidth) ) {
            alignmentFunction = CPTAlignIntegralPointToUserSpace;
        }
        else {
            alignmentFunction = CPTAlignPointToUserSpace;
        }

        CGContextBeginPath(context);

        for ( NSDecimalNumber *location in locations ) {
            NSDecimal locationDecimal = location.decimalValue;

            if ( labeledRange && ![labeledRange contains:locationDecimal] ) {
                continue;
            }

            startPlotPoint[selfCoordinate] = locationDecimal;
            endPlotPoint[selfCoordinate]   = locationDecimal;

            // Start point
            CGPoint startViewPoint = [thePlotSpace plotAreaViewPointForPlotPoint:startPlotPoint numberOfCoordinates:2];
            startViewPoint.x += originTransformed.x;
            startViewPoint.y += originTransformed.y;

            // End point
            CGPoint endViewPoint = [thePlotSpace plotAreaViewPointForPlotPoint:endPlotPoint numberOfCoordinates:2];
            endViewPoint.x += originTransformed.x;
            endViewPoint.y += originTransformed.y;

            // Align to pixels
            startViewPoint = alignmentFunction(context, startViewPoint);
            endViewPoint   = alignmentFunction(context, endViewPoint);

            // Add grid line
            CGContextMoveToPoint(context, startViewPoint.x, startViewPoint.y);
            CGContextAddLineToPoint(context, endViewPoint.x, endViewPoint.y);
        }

        // Stroke grid lines
        [lineStyle setLineStyleInContext:context];
        [lineStyle strokePathInContext:context];
    }
}

/// @endcond

#pragma mark -
#pragma mark Background Bands

/// @cond

-(void)drawBackgroundBandsInContext:(CGContextRef)context
{
    CPTFillArray bandArray = self.alternatingBandFills;
    NSUInteger bandCount   = bandArray.count;

    if ( bandCount > 0 ) {
        CPTNumberArray locations = [self.majorTickLocations allObjects];

        if ( locations.count > 0 ) {
            CPTPlotSpace *thePlotSpace = self.plotSpace;

            CPTCoordinate selfCoordinate = self.coordinate;
            CPTMutablePlotRange *range   = [[thePlotSpace plotRangeForCoordinate:selfCoordinate] mutableCopy];
            if ( range ) {
                CPTPlotRange *theVisibleRange = self.visibleRange;
                if ( theVisibleRange ) {
                    [range intersectionPlotRange:theVisibleRange];
                }
            }

            CPTCoordinate orthogonalCoordinate   = CPTOrthogonalCoordinate(selfCoordinate);
            CPTMutablePlotRange *orthogonalRange = [[thePlotSpace plotRangeForCoordinate:orthogonalCoordinate] mutableCopy];
            CPTPlotRange *theGridLineRange       = self.gridLinesRange;

            if ( theGridLineRange ) {
                [orthogonalRange intersectionPlotRange:theGridLineRange];
            }

            NSDecimal zero                   = CPTDecimalFromInteger(0);
            NSSortDescriptor *sortDescriptor = nil;
            if ( range ) {
                if ( CPTDecimalGreaterThanOrEqualTo(range.lengthDecimal, zero) ) {
                    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
                }
                else {
                    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO];
                }
            }
            else {
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
            }
            locations = [locations sortedArrayUsingDescriptors:@[sortDescriptor]];

            NSUInteger bandIndex = 0;
            id null              = [NSNull null];
            NSDecimal lastLocation;
            if ( range ) {
                lastLocation = range.locationDecimal;
            }
            else {
                lastLocation = CPTDecimalNaN();
            }

            NSDecimal startPlotPoint[2];
            NSDecimal endPlotPoint[2];
            if ( orthogonalRange ) {
                startPlotPoint[orthogonalCoordinate] = orthogonalRange.locationDecimal;
                endPlotPoint[orthogonalCoordinate]   = orthogonalRange.endDecimal;
            }
            else {
                startPlotPoint[orthogonalCoordinate] = CPTDecimalNaN();
                endPlotPoint[orthogonalCoordinate]   = CPTDecimalNaN();
            }

            for ( NSDecimalNumber *location in locations ) {
                NSDecimal currentLocation = [location decimalValue];
                if ( !CPTDecimalEquals(CPTDecimalSubtract(currentLocation, lastLocation), zero) ) {
                    CPTFill *bandFill = bandArray[bandIndex++];
                    bandIndex %= bandCount;

                    if ( bandFill != null ) {
                        // Start point
                        startPlotPoint[selfCoordinate] = currentLocation;
                        CGPoint startViewPoint = [thePlotSpace plotAreaViewPointForPlotPoint:startPlotPoint numberOfCoordinates:2];

                        // End point
                        endPlotPoint[selfCoordinate] = lastLocation;
                        CGPoint endViewPoint = [thePlotSpace plotAreaViewPointForPlotPoint:endPlotPoint numberOfCoordinates:2];

                        // Fill band
                        CGRect fillRect = CPTRectMake( MIN(startViewPoint.x, endViewPoint.x),
                                                       MIN(startViewPoint.y, endViewPoint.y),
                                                       ABS(endViewPoint.x - startViewPoint.x),
                                                       ABS(endViewPoint.y - startViewPoint.y) );
                        [bandFill fillRect:CPTAlignIntegralRectToUserSpace(context, fillRect) inContext:context];
                    }
                }

                lastLocation = currentLocation;
            }

            // Fill space between last location and the range end
            NSDecimal endLocation;
            if ( range ) {
                endLocation = range.endDecimal;
            }
            else {
                endLocation = CPTDecimalNaN();
            }
            if ( !CPTDecimalEquals(lastLocation, endLocation) ) {
                CPTFill *bandFill = bandArray[bandIndex];

                if ( bandFill != null ) {
                    // Start point
                    startPlotPoint[selfCoordinate] = endLocation;
                    CGPoint startViewPoint = [thePlotSpace plotAreaViewPointForPlotPoint:startPlotPoint numberOfCoordinates:2];

                    // End point
                    endPlotPoint[selfCoordinate] = lastLocation;
                    CGPoint endViewPoint = [thePlotSpace plotAreaViewPointForPlotPoint:endPlotPoint numberOfCoordinates:2];

                    // Fill band
                    CGRect fillRect = CPTRectMake( MIN(startViewPoint.x, endViewPoint.x),
                                                   MIN(startViewPoint.y, endViewPoint.y),
                                                   ABS(endViewPoint.x - startViewPoint.x),
                                                   ABS(endViewPoint.y - startViewPoint.y) );
                    [bandFill fillRect:CPTAlignIntegralRectToUserSpace(context, fillRect) inContext:context];
                }
            }
        }
    }
}

-(void)drawBackgroundLimitsInContext:(CGContextRef)context
{
    CPTLimitBandArray limitArray = self.backgroundLimitBands;

    if ( limitArray.count > 0 ) {
        CPTPlotSpace *thePlotSpace = self.plotSpace;

        CPTCoordinate selfCoordinate = self.coordinate;
        CPTMutablePlotRange *range   = [[thePlotSpace plotRangeForCoordinate:selfCoordinate] mutableCopy];

        if ( range ) {
            CPTPlotRange *theVisibleRange = self.visibleRange;
            if ( theVisibleRange ) {
                [range intersectionPlotRange:theVisibleRange];
            }
        }

        CPTCoordinate orthogonalCoordinate   = CPTOrthogonalCoordinate(selfCoordinate);
        CPTMutablePlotRange *orthogonalRange = [[thePlotSpace plotRangeForCoordinate:orthogonalCoordinate] mutableCopy];
        CPTPlotRange *theGridLineRange       = self.gridLinesRange;

        if ( theGridLineRange ) {
            [orthogonalRange intersectionPlotRange:theGridLineRange];
        }

        NSDecimal startPlotPoint[2];
        NSDecimal endPlotPoint[2];
        startPlotPoint[orthogonalCoordinate] = orthogonalRange.locationDecimal;
        endPlotPoint[orthogonalCoordinate]   = orthogonalRange.endDecimal;

        for ( CPTLimitBand *band in self.backgroundLimitBands ) {
            CPTFill *bandFill = band.fill;

            if ( bandFill ) {
                CPTMutablePlotRange *bandRange = [band.range mutableCopy];
                if ( bandRange ) {
                    [bandRange intersectionPlotRange:range];

                    // Start point
                    startPlotPoint[selfCoordinate] = bandRange.locationDecimal;
                    CGPoint startViewPoint = [thePlotSpace plotAreaViewPointForPlotPoint:startPlotPoint numberOfCoordinates:2];

                    // End point
                    endPlotPoint[selfCoordinate] = bandRange.endDecimal;
                    CGPoint endViewPoint = [thePlotSpace plotAreaViewPointForPlotPoint:endPlotPoint numberOfCoordinates:2];

                    // Fill band
                    CGRect fillRect = CPTRectMake( MIN(startViewPoint.x, endViewPoint.x),
                                                   MIN(startViewPoint.y, endViewPoint.y),
                                                   ABS(endViewPoint.x - startViewPoint.x),
                                                   ABS(endViewPoint.y - startViewPoint.y) );
                    [bandFill fillRect:CPTAlignIntegralRectToUserSpace(context, fillRect) inContext:context];
                }
            }
        }
    }
}

/// @endcond

#pragma mark -
#pragma mark Description

/// @cond

-(NSString *)description
{
    CPTPlotRange *range    = [self.plotSpace plotRangeForCoordinate:self.coordinate];
    CGPoint startViewPoint = [self viewPointForCoordinateValue:range.location];
    CGPoint endViewPoint   = [self viewPointForCoordinateValue:range.end];

    return [NSString stringWithFormat:@"<%@ with range: %@ viewCoordinates: %@ to %@>",
            [super description],
            range,
            CPTStringFromPoint(startViewPoint),
            CPTStringFromPoint(endViewPoint)];
}

/// @endcond

#pragma mark -
#pragma mark Titles

/// @cond

// Center title in the plot range by default
-(NSNumber *)defaultTitleLocation
{
    NSNumber *location;

    CPTPlotSpace *thePlotSpace  = self.plotSpace;
    CPTCoordinate theCoordinate = self.coordinate;

    CPTPlotRange *axisRange = [thePlotSpace plotRangeForCoordinate:theCoordinate];

    if ( axisRange ) {
        CPTScaleType scaleType = [thePlotSpace scaleTypeForCoordinate:theCoordinate];

        switch ( scaleType ) {
            case CPTScaleTypeLinear:
                location = axisRange.midPoint;
                break;

            case CPTScaleTypeLog:
            {
                double loc = axisRange.locationDouble;
                double end = axisRange.endDouble;

                if ( (loc > 0.0) && (end >= 0.0) ) {
                    location = @( pow(10.0, ( log10(loc) + log10(end) ) / 2.0) );
                }
                else {
                    location = axisRange.midPoint;
                }
            }
            break;

            case CPTScaleTypeLogModulus:
            {
                double loc = axisRange.locationDouble;
                double end = axisRange.endDouble;

                location = @( CPTInverseLogModulus( ( CPTLogModulus(loc) + CPTLogModulus(end) ) / 2.0 ) );
            }
            break;

            default:
                location = axisRange.midPoint;
                break;
        }
    }
    else {
        location = @0;
    }

    return location;
}

/// @endcond

#pragma mark -
#pragma mark Accessors

/// @cond

-(void)setAxisConstraints:(CPTConstraints *)newConstraints
{
    if ( ![axisConstraints isEqualToConstraint:newConstraints] ) {
        axisConstraints = newConstraints;
        [self setNeedsDisplay];
        [self setNeedsLayout];
    }
}

-(void)setOrthogonalPosition:(NSNumber *)newPosition
{
    BOOL needsUpdate = YES;

    if ( newPosition ) {
        needsUpdate = ![orthogonalPosition isEqualToNumber:newPosition];
    }

    if ( needsUpdate ) {
        orthogonalPosition = newPosition;
        [self setNeedsDisplay];
        [self setNeedsLayout];
    }
}

-(void)setCoordinate:(CPTCoordinate)newCoordinate
{
    if ( self.coordinate != newCoordinate ) {
        [super setCoordinate:newCoordinate];
        switch ( newCoordinate ) {
            case CPTCoordinateX:
                switch ( self.labelAlignment ) {
                    case CPTAlignmentLeft:
                    case CPTAlignmentCenter:
                    case CPTAlignmentRight:
                        // ok--do nothing
                        break;

                    default:
                        self.labelAlignment = CPTAlignmentCenter;
                        break;
                }
                break;

            case CPTCoordinateY:
                switch ( self.labelAlignment ) {
                    case CPTAlignmentTop:
                    case CPTAlignmentMiddle:
                    case CPTAlignmentBottom:
                        // ok--do nothing
                        break;

                    default:
                        self.labelAlignment = CPTAlignmentMiddle;
                        break;
                }
                break;

            default:
                [NSException raise:NSInvalidArgumentException format:@"Invalid coordinate: %lu", (unsigned long)newCoordinate];
                break;
        }
    }
}

/// @endcond

@end
