/* eslint-disable react/jsx-props-no-spreading */
import {
  DataTable,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableHeader,
  TableRow,
  Button,
  Loading
} from 'carbon-components-react';
import React, { useEffect, useState } from 'react';
import { StarFilled16 } from '@carbon/icons-react';


const headers = [
  { key: 'position', header: 'Pos' },
  { key: 'name', header: 'Player' },
  { key: 'questions_answered', header: 'Question #' },
  { key: 'rank', header: 'Rank' },
  { key: 'time', header: 'Time' },
];

const LeaderBoard = ({
  restart,
  isLoading,
  data,
  currentPlayerId
}) => {
  const [rows, setRows] = useState([]);

  useEffect(() => {
    setRows(data.map(d => {
      return {
        time: formatDuration(new Date(d.end_time).getTime() - new Date(d.begin_time).getTime()),
        ...d
      }
    }))

  }, [data])

  function formatDuration(mils) {
    const hours = Math.floor(mils/3600000).toString().padStart(2,'0');
    const minutes = Math.floor((mils%3600000)/60000).toString().padStart(2,'0');
    const seconds =  Math.floor(((mils%3600000)%60000)/1000).toString().padStart(2,'0');
    const miliseconds =  (((mils%3600000)%60000)%1000).toString().padStart(2,'0');

    return `${hours}:${minutes}:${seconds}.${miliseconds}`
  } 
 
  return (
    <div className="leaderboard-panel">
      
      <DataTable
        rows={rows}
        headers={headers}
        render={({
          rows: tableRows,
          headers: tableHeaders,
          getHeaderProps,
          getRowProps,
          getTableProps,
          getTableContainerProps,
        }) => {
          return (
            <div>  
            <div className="restart">
              <Button 
              kind="tertiary"
              onClick={restart}
              >
                Restart?
              </Button>
            </div>   
            <TableContainer title="Leaderboard" {...getTableContainerProps()}>
              <Table {...getTableProps()} isSortable>
                <TableHead>
                  <TableRow>
                    {tableHeaders.map((header) => (
                      <TableHeader {...getHeaderProps({ header })} isSortable>
                        {header.header}
                      </TableHeader>
                    ))}
                  </TableRow>
                  
                </TableHead>
                <TableBody>
                  {tableRows.map((row) => (
                    <TableRow
                      {...getRowProps({
                        row,
                      })}
                      className={[
                        row.id === currentPlayerId ? 'current-player' : '',
                      ].join(' ')}
                    >
                      {row.cells.map(
                        (
                          cell,
                          index,
                        ) => (
                          <TableCell key={cell.id}>
                            <div>
                              {index === 0 && (
                                <StarFilled16
                                  className={
                                    cell.value === 1
                                      ? 'star-icon'
                                      : 'start-icon hidden'
                                  }
                                />
                              )}
                              <span>{cell.value}</span>
                            </div>
                          </TableCell>
                        ),
                      )}
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
          </TableContainer>
            </div>
          );
        }}
      />
      <Loading  active={isLoading} />
    </div>
  );
};

LeaderBoard.defaultProps = {
};

export default LeaderBoard;
