async function loadData() {
  const res = await fetch('./size-history.json');
  const data = await res.json();

  const table = document.createElement('table');
  table.innerHTML = `
    <thead>
      <tr>
        <th>Date</th>
        <th>Commit</th>
        <th>Committer</th>
        <th>Size (MB)</th>
      </tr>
    </thead>
    <tbody>
      ${data
        .map(
          (entry) => `
        <tr>
          <td>${entry.date}</td>
          <td><code>${entry.commit.slice(0, 7)}</code></td>
          <td>${entry.committer}</td>
          <td>${(entry.size / 1024 / 1024).toFixed(2)} MB</td>
        </tr>
      `
        )
        .join('')}
    </tbody>
  `;

  const container = document.getElementById('size-table');
  container.innerHTML = '';
  container.appendChild(table);
}

loadData();
