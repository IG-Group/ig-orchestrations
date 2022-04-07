package com.ig.orchestrations.us.rfed.avro.v1.fix50sp2;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import com.ig.orchestrations.us.rfed.avro.v1.fix50sp2.codesets.ExecTypeCodeSet;
import com.ig.orchestrations.us.rfed.avro.v1.fix50sp2.codesets.OrdStatusCodeSet;
import com.ig.orchestrations.us.rfed.avro.v1.fix50sp2.codesets.OrdTypeCodeSet;
import com.ig.orchestrations.us.rfed.avro.v1.fix50sp2.codesets.SideCodeSet;
import com.ig.orchestrations.us.rfed.avro.v1.fix50sp2.groups.SecAltIDGrpItem;
import com.ig.orchestrations.us.rfed.avro.v1.fix50sp2.messages.ExecutionReport;

class ExecutionReportTest {

    String testFileName = "bid-responses.avro";
    File testFile = new File(testFileName);
	
	@AfterEach
	public void after() {
		if (this.testFile.exists()) {
			this.testFile.delete();
		}
	}
	
	@Test
	void testExecutionReportSerialisation() throws IOException {
		SecAltIDGrpItem[] secAltIdGrpItems = new SecAltIDGrpItem[2];
		secAltIdGrpItems[0] = ExecutionReportExample.createSecAltIDGrpItem("id-123");
		secAltIdGrpItems[1] = ExecutionReportExample.createSecAltIDGrpItem("id-abc");
		
		String sendingTime0 = "20220311-15:15:15";
		String sendingTime1 = "20220312-16:16:16";

		List<ExecutionReport> executionReports = new ArrayList<ExecutionReport>();
		executionReports.add(ExecutionReportExample.createExecutionReport(sendingTime0, "order1", "accountA", secAltIdGrpItems, "execID-10", ExecTypeCodeSet.NEW, OrdStatusCodeSet.NEW, "symbolA", SideCodeSet.BUY, "10.0", OrdTypeCodeSet.MARKET, "10.0", "0.0"));
		executionReports.add(ExecutionReportExample.createExecutionReport(sendingTime1, "order1", "accountA",  secAltIdGrpItems, "execID-11", ExecTypeCodeSet.TRADE, OrdStatusCodeSet.FILLED, "symbolA", SideCodeSet.BUY,"10.0", OrdTypeCodeSet.MARKET, "0.0",  "10.0"));
		ExecutionReportExample.writeExecutionReports(executionReports, testFile);
		List<ExecutionReport> readResponses = ExecutionReportExample.readExecutionReports(testFile);
		assertEquals(readResponses.get(0), executionReports.get(0));
		assertEquals(readResponses.get(1), executionReports.get(1));
	}

}
