export const cardRow = (label, value) => (
    $('<div></div>').addClass('row').append(
        $('<h3></h3>')
            .addClass('col')
            .text(label),
        $('<div></div>')
            .addClass('col')
            .text(value),
        $('<input>')
            .attr({ type: 'hidden', name: label, value: value })
    )
);