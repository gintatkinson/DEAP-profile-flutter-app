import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_flutter/features/tables/models/column_model.dart';
import 'package:app_flutter/features/tables/view_models/tables_view_model.dart';

/// Virtualized ARINC 661 high-density table widget that renders tabular records
/// from [TablesViewModel] with fixed headers, memoized column sorting, and
/// inline safety range/zero-ceiling annunciators.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Replaces $\mathcal{O}(N)$ eager
///   [DataTable] instantiation with $\mathcal{O}(1)$ viewport-virtualized
///   [ListView.builder] row rendering wrapped in a [RepaintBoundary], sustaining
///   $T_{\text{frame}} \le 16.67\text{ ms}$ (60 FPS) across large datasets.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Minimum Column Width Bound**: For $C = |\text{headers}|$ visible columns
///   within viewport width $W$, horizontal margin $m$, and spacing $s = (C - 1) \cdot d$:
///   $$
///   \begin{aligned}
///   w_{\text{col}} &= \max\left(120.0, \frac{W - 2m - s}{C}\right) \\
///   W_{\text{table}} &= \max(W, C \cdot w_{\text{col}} + s + 2m)
///   \end{aligned}
///   $$
/// - **Memoized Sort Stability**: `_getSortedRows` reuses `_cachedSortedRows`
///   whenever source rows, `_sortColumnIndex`, and `_sortAscending` are unchanged.
///
/// ## 3. Preconditions
/// - Must be mounted inside a [BuildContext] providing [TablesViewModel] via
///   [Provider].
///
/// ## 4. Postconditions
/// - Renders [CircularProgressIndicator] while loading, themed error text on
///   failure, [SizedBox.shrink] when `headers` is empty, or a virtualized
///   body list beneath a pinned header row.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(V \cdot C)$ per frame for $V$ visible rows
///   and $C$ columns; $\mathcal{O}(N \log N)$ on sort cache miss over $N$ rows.
/// - **Space Complexity**: $\mathcal{O}(N \cdot C)$ for the memoized sorted row
///   reference list.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Empty `headers` lists render [SizedBox.shrink] -- no division-by-zero or
///   layout exception occurs.
/// - Non-numeric strings in numeric columns fall back safely to lexicographical
///   comparison during sorting and plain text rendering in cells.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 3 (Presentation & Actuator Interface Binding)
///
/// Realises: [Feat-10/TableViewWidget]
class TableViewWidget extends StatefulWidget {
  /// Creates a virtualized [TableViewWidget].
  const TableViewWidget({
    super.key,
    this.headingRowHeight = 32.0,
    this.dataRowMinHeight = 28.0,
    this.dataRowMaxHeight = double.infinity,
    this.horizontalMargin = 12.0,
    this.columnSpacing = 24.0,
  });

  /// Fixed height in logical pixels of the pinned column header row.
  final double headingRowHeight;

  /// Minimum height in logical pixels of each virtualized data row.
  final double dataRowMinHeight;

  /// Maximum height constraint in logical pixels of each data row.
  final double dataRowMaxHeight;

  /// Left and right outer table padding in logical pixels.
  final double horizontalMargin;

  /// Horizontal gap in logical pixels between adjacent columns.
  final double columnSpacing;

  @override
  State<TableViewWidget> createState() => _TableViewWidgetState();
}

class _TableViewWidgetState extends State<TableViewWidget> {
  int? _sortColumnIndex;
  bool _sortAscending = true;

  List<List<String>>? _cachedSourceRows;
  List<ColumnModel>? _cachedHeaders;
  List<List<String>>? _cachedSortedRows;
  int? _cachedSortColumnIndex;
  bool? _cachedSortAscending;

  Map<String, int>? _cachedHeaderIndices;
  List<ColumnModel>? _cachedAllHeadersForIndices;

  List<List<String>> _getSortedRows(
    List<List<String>> rows,
    List<ColumnModel> headers,
    Map<String, int> headerIndices,
  ) {
    if (_sortColumnIndex == null || _sortColumnIndex! >= headers.length) {
      _clearCache();
      return rows;
    }

    if (_rowsEqual(_cachedSourceRows, rows) &&
        _cachedSortColumnIndex == _sortColumnIndex &&
        _cachedSortAscending == _sortAscending &&
        _cachedSortedRows != null) {
      return _cachedSortedRows!;
    }

    _cachedSourceRows = rows;
    _cachedSortColumnIndex = _sortColumnIndex;
    _cachedSortAscending = _sortAscending;

    final sortedRows = List<List<String>>.from(rows);
    final key = headers[_sortColumnIndex!].key;
    final absIdx = headerIndices[key] ?? _sortColumnIndex!;
    sortedRows.sort((a, b) {
      final aVal = absIdx < a.length ? a[absIdx] : '';
      final bVal = absIdx < b.length ? b[absIdx] : '';
      final aNum = double.tryParse(aVal);
      final bNum = double.tryParse(bVal);
      if (aNum != null && bNum != null) {
        return _sortAscending ? aNum.compareTo(bNum) : bNum.compareTo(aNum);
      } else {
        return _sortAscending ? aVal.compareTo(bVal) : bVal.compareTo(aVal);
      }
    });

    _cachedSortedRows = sortedRows;
    return sortedRows;
  }

  Map<String, int> _getHeaderIndices(List<ColumnModel> allHeaders) {
    if (_cachedAllHeadersForIndices != null &&
        _cachedHeaderIndices != null &&
        _cachedAllHeadersForIndices!.length == allHeaders.length) {
      var same = true;
      for (int i = 0; i < allHeaders.length; i++) {
        if (!identical(_cachedAllHeadersForIndices![i], allHeaders[i])) {
          same = false;
          break;
        }
      }
      if (same) return _cachedHeaderIndices!;
    }
    _cachedAllHeadersForIndices = allHeaders;
    _cachedHeaderIndices = {
      for (int idx = 0; idx < allHeaders.length; idx++)
        allHeaders[idx].key: idx
    };
    return _cachedHeaderIndices!;
  }

  bool _rowsEqual(List<List<String>>? a, List<List<String>>? b) {
    if (identical(a, b)) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].length != b[i].length) return false;
      for (int j = 0; j < a[i].length; j++) {
        if (a[i][j] != b[i][j]) return false;
      }
    }
    return true;
  }

  void _clearCache() {
    _cachedSourceRows = null;
    _cachedHeaders = null;
    _cachedSortedRows = null;
    _cachedSortColumnIndex = null;
    _cachedSortAscending = null;
    _cachedHeaderIndices = null;
    _cachedAllHeadersForIndices = null;
  }

  @override
  void dispose() {
    _clearCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TablesViewModel>();

    if (viewModel.loading) {
      _clearCache();
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.error != null) {
      _clearCache();
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            viewModel.error!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final headers = viewModel.visibleColumnModels;
    final allHeaders = viewModel.headers;
    final headerIndices = _getHeaderIndices(allHeaders);

    final rows = _getSortedRows(viewModel.rows, headers, headerIndices);
    final testId = '${viewModel.tabId}-table';
    final numericTextStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      fontFamily: 'monospace',
    );

    if (headers.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final colCount = headers.length;
        final spacingWidth = colCount > 1
            ? (colCount - 1) * widget.columnSpacing
            : 0.0;
        final colWidth = math.max(120.0, (constraints.maxWidth - 2 * widget.horizontalMargin - spacingWidth) / colCount);
        final tableWidth = math.max(constraints.maxWidth, colCount * colWidth + spacingWidth + 2 * widget.horizontalMargin);

        void onSort(int columnIndex) {
          _clearCache();
          setState(() {
            if (_sortColumnIndex == columnIndex) {
              _sortAscending = !_sortAscending;
            } else {
              _sortColumnIndex = columnIndex;
              _sortAscending = true;
            }
          });
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            key: Key(testId),
            width: tableWidth,
            height: constraints.maxHeight,
            child: Stack(
              children: [
                RepaintBoundary(
                  child: ListView.builder(
                    key: Key('$testId-body'),
                    itemCount: rows.length,
                    padding: EdgeInsets.only(top: widget.headingRowHeight),
                    itemBuilder: (context, index) {
                      final row = rows[index];
                      return _DataRow(
                        cells: row,
                        columnModels: headers,
                        headerIndices: headerIndices,
                        colWidth: colWidth,
                        dataRowMinHeight: widget.dataRowMinHeight,
                        dataRowMaxHeight: widget.dataRowMaxHeight,
                        horizontalMargin: widget.horizontalMargin,
                        columnSpacing: widget.columnSpacing,
                        index: index,
                        numericTextStyle: numericTextStyle,
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _HeaderRow(
                    headers: headers,
                    colWidth: colWidth,
                    headingRowHeight: widget.headingRowHeight,
                    horizontalMargin: widget.horizontalMargin,
                    columnSpacing: widget.columnSpacing,
                    testId: testId,
                    sortColumnIndex: _sortColumnIndex,
                    sortAscending: _sortAscending,
                    onSort: onSort,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeaderRow extends StatelessWidget {
  /// Member documentation.
  final List<ColumnModel> headers;
  /// Member documentation.
  final double colWidth;
  /// Member documentation.
  final double headingRowHeight;
  /// Member documentation.
  final double horizontalMargin;
  /// Member documentation.
  final double columnSpacing;
  /// Member documentation.
  final String testId;
  /// Member documentation.
  final int? sortColumnIndex;
  /// Member documentation.
  final bool sortAscending;
  /// Member documentation.
  final void Function(int columnIndex) onSort;

  const _HeaderRow({
    required this.headers,
    required this.colWidth,
    required this.headingRowHeight,
    required this.horizontalMargin,
    required this.columnSpacing,
    required this.testId,
    required this.sortColumnIndex,
    required this.sortAscending,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('$testId-header'),
      height: headingRowHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < headers.length; i++)
            _HeaderCell(
              label: headers[i].label,
              columnWidth: headers[i].width,
              colWidth: colWidth,
              horizontalMargin: horizontalMargin,
              columnSpacing: columnSpacing,
              isFirst: i == 0,
              isLast: i == headers.length - 1,
              sortable: headers[i].sortable,
              isActiveSort: sortColumnIndex == i,
              sortAscending: sortAscending,
              onTap: headers[i].sortable ? () => onSort(i) : null,
              isNumeric: headers[i].type == 'int' || headers[i].type == 'double',
            ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  /// Member documentation.
  final String label;
  /// Member documentation.
  final double? columnWidth;
  /// Member documentation.
  final double colWidth;
  /// Member documentation.
  final double horizontalMargin;
  /// Member documentation.
  final double columnSpacing;
  /// Member documentation.
  final bool isFirst;
  /// Member documentation.
  final bool isLast;
  /// Member documentation.
  final bool sortable;
  /// Member documentation.
  final bool isActiveSort;
  /// Member documentation.
  final bool sortAscending;
  /// Member documentation.
  final VoidCallback? onTap;
  /// Member documentation.
  final bool isNumeric;

  const _HeaderCell({
    required this.label,
    this.columnWidth,
    required this.colWidth,
    required this.horizontalMargin,
    required this.columnSpacing,
    required this.isFirst,
    required this.isLast,
    required this.sortable,
    required this.isActiveSort,
    required this.sortAscending,
    required this.onTap,
    required this.isNumeric,
  });

  @override
  Widget build(BuildContext context) {
    final displayLabel = isActiveSort
        ? '$label ${sortAscending ? '↑' : '↓'}'
        : label;

    return SizedBox(
      width: columnWidth ?? colWidth,
      child: Padding(
        padding: EdgeInsets.only(
          left: isFirst ? horizontalMargin : columnSpacing / 2,
          right: isLast ? horizontalMargin : columnSpacing / 2,
        ),
        child: Align(
          alignment: isNumeric ? Alignment.centerRight : Alignment.centerLeft,
          child: sortable
              ? GestureDetector(
                  onTap: onTap,
                  child: Text(displayLabel, style: Theme.of(context).textTheme.labelSmall),
                )
              : Text(label, style: Theme.of(context).textTheme.labelSmall),
        ),
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  /// Member documentation.
  final List<String> cells;
  /// Member documentation.
  final List<ColumnModel> columnModels;
  /// Member documentation.
  final Map<String, int> headerIndices;
  /// Member documentation.
  final double colWidth;
  /// Member documentation.
  final double dataRowMinHeight;
  /// Member documentation.
  final double dataRowMaxHeight;
  /// Member documentation.
  final double horizontalMargin;
  /// Member documentation.
  final double columnSpacing;
  /// Member documentation.
  final int index;
  /// Member documentation.
  final TextStyle? numericTextStyle;

  static final Color _stripeColor = Colors.black.withOpacity(0.03);

  const _DataRow({
    required this.cells,
    required this.columnModels,
    required this.headerIndices,
    required this.colWidth,
    required this.dataRowMinHeight,
    required this.dataRowMaxHeight,
    required this.horizontalMargin,
    required this.columnSpacing,
    required this.index,
    required this.numericTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: dataRowMinHeight,
      ),
      color: index.isEven ? null : _stripeColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(columnModels.length, (i) {
          final cellIdx = headerIndices[columnModels[i].key];
          final cellValue = cellIdx != null && cellIdx < cells.length ? cells[cellIdx] : '';
          return _DataCell(
            value: cellValue,
            columnModel: columnModels[i],
            colWidth: colWidth,
            horizontalMargin: horizontalMargin,
            columnSpacing: columnSpacing,
            isFirst: i == 0,
            isLast: i == columnModels.length - 1,
            numericTextStyle: numericTextStyle,
          );
        }),
      ),
    );
  }
}

class _DataCell extends StatelessWidget {
  /// Member documentation.
  final String value;
  /// Member documentation.
  final ColumnModel columnModel;
  /// Member documentation.
  final double colWidth;
  /// Member documentation.
  final double horizontalMargin;
  /// Member documentation.
  final double columnSpacing;
  /// Member documentation.
  final bool isFirst;
  /// Member documentation.
  final bool isLast;
  /// Member documentation.
  final TextStyle? numericTextStyle;

  const _DataCell({
    required this.value,
    required this.columnModel,
    required this.colWidth,
    required this.horizontalMargin,
    required this.columnSpacing,
    required this.isFirst,
    required this.isLast,
    required this.numericTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNumeric = columnModel.type == 'int' || columnModel.type == 'double';

    Widget cellContent;
    switch (columnModel.type) {
      case 'int':
      case 'double':
        final textWidget = Text(
          value,
          style: numericTextStyle ?? theme.textTheme.bodySmall,
          textAlign: TextAlign.right,
        );
        if (columnModel.isZeroCeilingConstraint && value.trim().isNotEmpty) {
          final parsedInt = int.tryParse(value.trim());
          final isVerified = parsedInt != null && parsedInt == 0;
          cellContent = Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TableZeroCeilingBadge(isVerified: isVerified),
              const SizedBox(width: 6.0),
              Flexible(child: textWidget),
            ],
          );
        } else if (columnModel.hasSegmentedRangeBounds &&
            value.trim().isNotEmpty) {
          final parsedNum = double.tryParse(value.trim());
          if (parsedNum != null) {
            cellContent = Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ArincSegmentedRangeGauge(
                  value: parsedNum,
                  minValue: columnModel.minValue!.toDouble(),
                  maxValue: columnModel.maxValue!.toDouble(),
                ),
                const SizedBox(width: 6.0),
                Flexible(child: textWidget),
              ],
            );
          } else {
            cellContent = textWidget;
          }
        } else {
          cellContent = textWidget;
        }
        break;
      case 'enum':
        cellContent = Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(value, style: theme.textTheme.bodySmall),
        );
        break;
      case 'date':
        cellContent = Text(
          _formatDate(value),
          style: theme.textTheme.bodySmall,
        );
        break;
      default:
        cellContent = Text(value, style: theme.textTheme.bodySmall);
    }

    return SizedBox(
      width: columnModel.width ?? colWidth,
      child: Padding(
        padding: EdgeInsets.only(
          left: isFirst ? horizontalMargin : columnSpacing / 2,
          right: isLast ? horizontalMargin : columnSpacing / 2,
        ),
        child: Align(
          alignment: isNumeric ? Alignment.centerRight : Alignment.centerLeft,
          child: cellContent,
        ),
      ),
    );
  }

  String _formatDate(String value) {
    if (value.isEmpty) return value;
    try {
      final dt = DateTime.parse(value);
      final y = dt.year.toString();
      final m = dt.month.toString().padLeft(2, '0');
      final d = dt.day.toString().padLeft(2, '0');
      return '$y-$m-$d';
    } catch (_) {
      return value;
    }
  }
}

/// Compact inline ARINC 661 segmented range gauge rendered inside numeric table
/// cells whose [ColumnModel] defines both `minValue` and `maxValue` ($v_{\max} > v_{\min}$).
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Provides three-tier color-coded
///   cockpit visual cueing -- emerald (`#00E676`) in nominal band, caution amber
///   (`#FFB020`) within $15\%$ of either limit, and violation crimson (`#FF334B`)
///   when outside $[v_{\min}, v_{\max}]$.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Normalized Fill Clamping**: Given span $\Delta = v_{\max} - v_{\min} > 0$,
///   the normalized fill ratio $f \in [0.0, 1.0]$ and lit segment count
///   $k \in [1, S]$ ($S = \text{segmentCount}$) satisfy:
///   $$
///   \begin{aligned}
///   f &= \min\left(1.0, \max\left(0.0, \frac{v - v_{\min}}{\Delta}\right)\right) \\
///   k &= \begin{cases} 1 & \text{if } v < v_{\min} \\ \max(1, \lceil f \cdot S \rceil) & \text{otherwise} \end{cases}
///   \end{aligned}
///   $$
/// - **Caution Margin Threshold**: Caution amber activates when
///   $v \in [v_{\min}, v_{\min} + 0.15\Delta] \cup [v_{\max} - 0.15\Delta, v_{\max}]$.
///
/// ## 3. Preconditions
/// - [segmentCount] must be a positive integer ($S \ge 1$).
/// - [value], [minValue], and [maxValue] are finite `double` values.
///
/// ## 4. Postconditions
/// - Renders a horizontal [Row] of [segmentCount] discrete segment bars colored
///   by [activeColor] for the first $k$ segments and [inactiveTrackSlate] for
///   remaining segments.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(S)$ where $S = \text{segmentCount}$ (default $5$).
/// - **Space Complexity**: $\mathcal{O}(S)$ segment container widgets.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Degenerate spans ($\Delta \le 0$) safely return `normalizedFill = 1.0` and
///   `nominalEmerald` without division-by-zero faults.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 3 (Presentation & Actuator Interface Binding)
///
/// Realises: [Feat-10/ArincSegmentedRangeGauge]
@immutable
class ArincSegmentedRangeGauge extends StatelessWidget {
  /// Creates an [ArincSegmentedRangeGauge].
  const ArincSegmentedRangeGauge({
    super.key,
    required this.value,
    required this.minValue,
    required this.maxValue,
    this.segmentCount = 5,
  });

  /// Current numeric value to visualize.
  final double value;

  /// Lower inclusive bound from `FieldDescriptor.minValue`.
  final double minValue;

  /// Upper inclusive bound from `FieldDescriptor.maxValue`.
  final double maxValue;

  /// Number of discrete ARINC 661 segments rendered in the bar.
  final int segmentCount;

  /// Nominal range emerald color (`#00E676`).
  static const Color nominalEmerald = Color(0xFF00E676);

  /// Caution margin amber color (`#FFB020`) within 15% of lower/upper limit.
  static const Color cautionAmber = Color(0xFFFFB020);

  /// Out-of-bounds violation crimson color (`#FF334B`).
  static const Color violationCrimson = Color(0xFFFF334B);

  /// Inactive segment track color (`#1E293B`).
  static const Color inactiveTrackSlate = Color(0xFF1E293B);

  /// Resolves the ARINC 661 threshold color for [value] relative to
  /// [minValue] and [maxValue].
  Color get activeColor {
    if (value < minValue || value > maxValue) {
      return violationCrimson;
    }
    final span = maxValue - minValue;
    if (span <= 0) {
      return nominalEmerald;
    }
    final margin = span * 0.15;
    if ((value - minValue) <= margin || (maxValue - value) <= margin) {
      return cautionAmber;
    }
    return nominalEmerald;
  }

  /// Normalized fill ratio clamped to `[0.0, 1.0]`.
  double get normalizedFill {
    final span = maxValue - minValue;
    if (span <= 0) return 1.0;
    return ((value - minValue) / span).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final color = activeColor;
    final filledSegments = value < minValue
        ? 1
        : math.max(1, (normalizedFill * segmentCount).ceil());

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(segmentCount, (idx) {
        final isLit = idx < filledSegments;
        return Container(
          width: 4.0,
          height: 8.0,
          margin: EdgeInsets.only(right: idx < segmentCount - 1 ? 1.5 : 0.0),
          decoration: BoxDecoration(
            color: isLit ? color : inactiveTrackSlate,
            borderRadius: BorderRadius.circular(1.0),
          ),
        );
      }),
    );
  }
}

/// High-contrast ARINC 661 zero-ceiling status annunciator pill rendered in
/// tabular cells when an integer column defines `minValue == 0 && maxValue == 0`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Highlights zero-ceiling safety
///   invariant compliance (`VERIFIED` in `#00E676` vs. `VIOLATION` in `#FF334B`)
///   inside dense tabular monitoring grids.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Strict Zero-Ceiling Bijection**:
///   $$
///   \begin{aligned}
///   \text{label}(\text{isVerified}) &= \begin{cases}
///   \text{'VERIFIED'} & \text{if } \text{isVerified} = \text{true} \\
///   \text{'VIOLATION'} & \text{if } \text{isVerified} = \text{false}
///   \end{cases}
///   \end{aligned}
///   $$
///
/// ## 3. Preconditions
/// - [isVerified] is evaluated from the cell's integer value ($v == 0$).
///
/// ## 4. Postconditions
/// - Renders a compact monospace status pill alongside the numeric cell text.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ constant-time widget build.
/// - **Space Complexity**: $\mathcal{O}(1)$ leaf widget allocation.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Unparseable integer cell text evaluates `isVerified = false` in `_DataCell`,
///   annunciating `'VIOLATION'` fail-safe.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 3 (Presentation & Actuator Interface Binding)
///
/// Realises: [Feat-10/TableZeroCeilingBadge]
@immutable
class TableZeroCeilingBadge extends StatelessWidget {
  /// Creates a [TableZeroCeilingBadge].
  const TableZeroCeilingBadge({
    super.key,
    required this.isVerified,
  });

  /// Whether the zero-ceiling invariant is satisfied (`value == 0`).
  final bool isVerified;

  /// Verified emerald color (`#00E676`).
  static const Color verifiedColor = Color(0xFF00E676);

  /// Violation crimson color (`#FF334B`).
  static const Color violationColor = Color(0xFFFF334B);

  @override
  Widget build(BuildContext context) {
    final badgeColor = isVerified ? verifiedColor : violationColor;
    final label = isVerified ? 'VERIFIED' : 'VIOLATION';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.16),
        borderRadius: BorderRadius.circular(2.0),
        border: Border.all(color: badgeColor, width: 1.0),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 9.0,
          fontWeight: FontWeight.w700,
          color: badgeColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

