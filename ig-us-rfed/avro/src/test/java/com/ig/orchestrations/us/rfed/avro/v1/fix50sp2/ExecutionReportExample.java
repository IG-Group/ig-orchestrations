package com.ig.orchestrations.us.rfed.avro.v1.fix50sp2;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.avro.file.DataFileReader;
import org.apache.avro.file.DataFileWriter;
import org.apache.avro.io.DatumReader;
import org.apache.avro.io.DatumWriter;
import org.apache.avro.specific.SpecificDatumReader;
import org.apache.avro.specific.SpecificDatumWriter;

import com.ig.orchestrations.us.rfed.avro.v1.fix50sp2.codesets.ExecTypeCodeSet;
import com.ig.orchestrations.us.rfed.avro.v1.fix50sp2.codesets.MsgTypeCodeSet;
import com.ig.orchestrations.us.rfed.avro.v1.fix50sp2.codesets.OrdStatusCodeSet;
import com.ig.orchestrations.us.rfed.avro.v1.fix50sp2.codesets.OrdTypeCodeSet;
import com.ig.orchestrations.us.rfed.avro.v1.fix50sp2.codesets.SecurityIDSourceCodeSet;
import com.ig.orchestrations.us.rfed.avro.v1.fix50sp2.codesets.SideCodeSet;
import com.ig.orchestrations.us.rfed.avro.v1.fix50sp2.groups.SecAltIDGrp;
import com.ig.orchestrations.us.rfed.avro.v1.fix50sp2.groups.SecAltIDGrpItem;
import com.ig.orchestrations.us.rfed.avro.v1.fix50sp2.messages.ExecutionReport;

public class ExecutionReportExample {
	
	public static ExecutionReport createExecutionReport(String sendingTime, String orderId, String account, SecAltIDGrpItem[] secAltIDGrpItems, String execID, ExecTypeCodeSet execType, OrdStatusCodeSet orderStatus, String symbol, SideCodeSet side, CharSequence orderQty, OrdTypeCodeSet ordType, String leavesQty, String cumQty) {
		// it does not make sense to set body length or checksum for an AVRO message but this example is based on a standard, un-customised orchestration
		SecAltIDGrp secAltIDGrp =  SecAltIDGrp.newBuilder().setSecAltIDGrp(Arrays.asList(secAltIDGrpItems)).build();
		return ExecutionReport.newBuilder().
			setMsgType(MsgTypeCodeSet.EXECUTION_REPORT).
			setSecAltIDGrp(secAltIDGrp).
			setSendingTime(sendingTime).
			setOrderID(orderId).
			setExecID(execID).
			setExecType(execType).
			setOrdStatus(orderStatus).
			setSymbol(symbol).
			setSide(side).
			setOrderQty(orderQty).
			setOrdType(ordType).
			setLeavesQty(leavesQty).
			setCumQty(cumQty).
			setAccount(account).build();
	}
	
	public static SecAltIDGrpItem createSecAltIDGrpItem(String id) {
		return SecAltIDGrpItem.newBuilder().setSecurityAltIDSource(SecurityIDSourceCodeSet.MARKETPLACE_ASSIGNED_IDENTIFIER).setSecurityAltID(id).build();
	}
	
	public static void writeExecutionReports(List<ExecutionReport> executionReports, File file) throws IOException {
		DatumWriter<ExecutionReport> datumWriter = new SpecificDatumWriter<ExecutionReport>(ExecutionReport.class);
		if (!executionReports.isEmpty()) {
			try(DataFileWriter<ExecutionReport> dataFileWriter = new DataFileWriter<ExecutionReport>(datumWriter)) {
				dataFileWriter.create(executionReports.get(0).getSchema(), file);
				executionReports.forEach(executionReport -> {
					try {
						dataFileWriter.append(executionReport);
					} catch (IOException e) {
						e.printStackTrace();
						throw new RuntimeException(e);
					}
				});
			}
		}
	}
	
	public static List<ExecutionReport> readExecutionReports(File file) throws IOException {
		List<ExecutionReport> responses = new ArrayList<>();
		DatumReader<ExecutionReport> datumReader = new SpecificDatumReader<ExecutionReport>(ExecutionReport.class);
		try(DataFileReader<ExecutionReport> dataFileReader = new DataFileReader<ExecutionReport>(file, datumReader)) {
			dataFileReader.forEach(r -> {responses.add(r);System.out.println(r);});
		}
		return responses;
	}
}
